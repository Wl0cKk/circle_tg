require 'streamio-ffmpeg'

class VideoProcessor
	attr_accessor :input, :output, :verbose
	
	def convert_to_note
		output_manager do
			movie = FFMPEG::Movie.new(@input)
			options = {
				video_codec: 'libx264',
				audio_codec: 'aac',
				video_bitrate: 500,
				audio_bitrate: 128,
				video_buffer_size: 1000,
				resolution: '640x640',
				preset: 'ultrafast', # https://superuser.com/questions/490683/cheat-sheets-and-preset-settings-that-actually-work-with-ffmpeg-1-0
				duration: 60, # this restriction applies to all
				custom: %w(-vf crop='min(iw,ih)':min(iw\,ih),scale=640:640,setsar=1)
			}
			movie.transcode(@output, options)
		end
	end

	def concat_to_mpeg
		output_manager do
			system("ffmpeg -f concat -safe 0 -i '#{@input}' -c copy '#{@output}'")
		end
	end

	def remove_junk
		File.delete(@input)  if File.exist?(@input)
		File.delete(@output) if File.exist?(@output)
	end

	private
	def output_manager
		original_stdout = STDOUT.clone
		original_stderr = STDERR.clone
		unless @verbose
			STDOUT.reopen(File.new('/dev/null', 'w'))
			STDERR.reopen(File.new('/dev/null', 'w'))
		end
		yield
	ensure
		STDOUT.reopen(original_stdout)
		STDERR.reopen(original_stderr)
	end
end