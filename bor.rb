require 'telegram/bot'
require 'httparty'
require 'colorize'
require_relative 'config.rb'
require_relative 'convert.rb'

BEGIN { system('clear') }

if ARGV.include?('-h') || ARGV.include?('--help')
	puts <<~HELP
		Usage: ruby bot.rb [options]
		Options:
		  --keep_files    Keep files after processing.
		  --verbose       Enable ffmpeg output.
		  --silent        Suppress all output.
		  -h, --help      Show this help message.
		Example:
		  ruby bot.rb --verbose		Specify parameters using spaces without commas.
	HELP
	exit
end

valid_args = {
	keep: '--keep_files',
	verbose: '--verbose',
	silent: '--silent'
}

valid_args_keys = valid_args.values 
invalid_args = ARGV.select { |arg| !valid_args_keys.include?(arg) }

if invalid_args.any?
	invalid_args_string = invalid_args.map { |arg| "#{arg} (invalid)" }.join(', ')
	abort "Invalid arguments: #{invalid_args_string}. See bor.rb -h for help.".red.bold
end

keep_files   = ARGV.include?(valid_args[:keep])
verbose_mode = ARGV.include?(valid_args[:verbose])
silent_mode  = ARGV.include?(valid_args[:silent])

if verbose_mode && silent_mode
	abort 'impossible to use --verbose and --silent at the same time'.red.bold
end

if silent_mode
	STDOUT.reopen(File.new('/dev/null', 'w'))
	STDERR.reopen(File.new('/dev/null', 'w'))
end

logo = File.read('logo.txt') if File.exist?('logo.txt')
logo.each_line do |line|
  print "#{line}".red.on_black
  sleep(0.05)
end

VIDEO_BASE = 'videos' 
Dir.mkdir(VIDEO_BASE) unless Dir.exist?(VIDEO_BASE)

Telegram::Bot::Client.run(TOKEN) do |bot|
	begin
        bot.listen do |msg|
            Thread.new {
                case msg.text
                when '/start'
                    puts sprintf(
                        "[ID: #{msg.chat.id}][%-10s%-20s: %-20s] [TIME: %-20s]\n",
                        "New message from ".green,
                        "#{msg.from.first_name}".green.bold, 
                        "#{msg.text}".black.on_white.italic,
                        "#{Time.now}".cyan.blink
                    )
                    bot.api.send_message(
                        chat_id: msg.chat.id, 
                        text: "Hello, *#{msg.from.first_name}*\ntelegram requirement:\n\\- Video no larger than 20MB\n\\- The duration of circle video will be limited to one minute",
                        parse_mode: 'MarkdownV2'
                    )
                end

                begin
                    if msg.video
                        puts sprintf(
                            "[ID: #{msg.chat.id}][%-10s %-20s - %-20s] [TIME: %-20s]\n", 
                            "#{msg.from.first_name}".green.bold, 
                            "sent the video".green, 
                            "#{msg.video.file_id}".black.on_white.italic,
                            "#{Time.now}".cyan.blink
                        )
                        video_file = bot.api.get_file(file_id: msg.video.file_id)
                        file_path = video_file.file_path
                        file_url = "https://api.telegram.org/file/bot#{TOKEN}/#{file_path}"
                        video_path = "#{VIDEO_BASE}/#{msg.video.file_id}"
                        converted_video_path = "#{video_path}-CONVERTED.mp4"
                        File.open(video_path, 'wb') { |f| f.write HTTParty.get(file_url).body }
                        
                        processor = VideoProcessor.new(video_path, converted_video_path, verbose_mode)
                        processor.convert_video_to_note
                        bot.api.send_video_note(chat_id: msg.chat.id, video_note: Faraday::UploadIO.new(converted_video_path, 'video/mp4'))
                        processor.remove_junk unless keep_files
                        
                        puts sprintf("[TIME: %-20s] [%-10s]\n", "#{Time.new}".cyan.blink, "Completed successfully".green.bold)
                    end
                rescue Telegram::Bot::Exceptions::ResponseError => e
                    bot.api.send_message(chat_id: msg.chat.id, text: "```\n#{e}```", parse_mode: 'MarkdownV2')
                    puts "#{e}".red.blink
                rescue FFMPEG::Error => e
                    puts "#{e}".red
                end
            } # Thread
        end
    rescue Interrupt
        puts "\n[#{Time.now}] Bot has been stopped\n".green.underline.italic
    end
end
