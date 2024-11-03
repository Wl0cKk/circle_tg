require 'rufus-scheduler'
require 'time'

class CaptionError < StandardError; end

class CaptionParser
    def self.parse(caption)
        return nil if caption.nil? || caption.strip.empty?
        caption = caption.strip.downcase
        case caption
        when '.'
            format_time(:in, Time.now)
        when /^(in|In|at|At) /
            caption.start_with?('at') ? parse_absolute_time(caption) : parse_relative_time(caption)
        else
            return nil
        end
    end

    private
    
    def self.add_duration(time, duration)
        duration.each { |value, unit|
            case unit
            when 'd' then time += value.to_i * 86400
            when 'h' then time += value.to_i * 3600
            when 'm' then time += value.to_i * 60
            when 's' then time += value.to_i
            end
        }
        return time
    end

    def self.parse_relative_time(caption)
        time = Time.now
        duration = caption.scan(/(\d+)([dhms])/)
        time = add_duration(time, duration)
        format_time(:in, time)
    end

    def self.parse_absolute_time(caption)
        time = Time.now
        time_parts = caption.sub(/^at\s*/, '').strip
        return nil unless valid_time_format?(time_parts)
        if time_parts =~ /(\d+)([dhms])/
            duration = time_parts.scan(/(\d+)([dhms])/)
            time = add_duration(time, duration)
            return format_time(:at, time)
        end
        if time_parts =~ /^\d{4}\/\d{1,2}\/\d{1,2} \d{1,2}:\d{1,2}:\d{1,2}/
            return format_time(:at, Time.parse(time_parts))
        elsif time_parts =~ /^\d{1,2}:\d{1,2}(:\d{1,2})?$/
            time = Time.parse("#{time.strftime('%Y/%m/%d')} #{time_parts}")
            return format_time(:at, time)
        end
        return nil
    end

    def self.valid_time_format?(time_parts)
        time_parts =~ /^\d{4}\/\d{1,2}\/\d{1,2} \d{1,2}:\d{1,2}:\d{1,2}$/ ||
        time_parts =~ /^\d{1,2}:\d{1,2}(:\d{1,2})?$/ ||
        time_parts =~ /(\d+)([dhms])/
    end

    def self.format_time(preposition, time)
        return { preposition: preposition, time: time.strftime('%Y/%m/%d %H:%M:%S') }
    end
end

class CaptionSchedule < CaptionParser
    def initialize
        @scheduler = Rufus::Scheduler.new
    end

    def schedule(caption)
        parsed_caption = self.class.parse(caption)
        if caption.strip == "."
            yield if block_given?
            return
        end
        raise CaptionError, "Invalid caption format" if parsed_caption.nil?
        preposition = parsed_caption[:preposition]
        time = parsed_caption[:time]
        delay_time = Time.parse(time) - Time.now
        @scheduler.send(preposition, time) do
            yield if block_given?
        end
    end

    def join
        @scheduler.join
    end

    def shutdown
        @scheduler.shutdown
    end
end
