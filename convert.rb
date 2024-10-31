require 'streamio-ffmpeg'

class VideoProcessor
	def initialize(input, output, verbose)
		@input = input
		@output = output
		@verbose = verbose
	end
	
	def convert_video_to_note
		original_stdout = STDOUT.clone
		original_stderr = STDERR.clone
		unless @verbose
			STDOUT.reopen(File.new('/dev/null', 'w'))
			STDERR.reopen(File.new('/dev/null', 'w'))
		end
		movie = FFMPEG::Movie.new(@input)
		options = {
			video_codec: 'libx264',
			audio_codec: 'aac',
			video_bitrate: 500,
			audio_bitrate: 128,
			video_max_bitrate: 500,
			video_buffer_size: 1000,
			resolution: '640x640',
			preset: 'medium',
			duration: 60,
			custom: %w(-vf crop='min(iw,ih)':min(iw\,ih),scale=640:640,setsar=1)
		}
		movie.transcode(@output, options)
		STDOUT.reopen(original_stdout)
		STDERR.reopen(original_stderr)
	end

	def remove_junk
		File.delete(@input)  if File.exist?(@input)
		File.delete(@output) if File.exist?(@output)
	end
end
