require 'rufus-scheduler'
require 'time'

class CaptionParser
    def self.parse(caption)
        return nil if caption.nil? || caption.strip.empty?
        caption = caption.strip.downcase
        case caption
        when '.' 
            format_time(Time.now, '.')
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
        format_time(time, 'in')
    end

    def self.parse_absolute_time(caption)
        time = Time.now
        time_parts = caption.sub(/^at\s*/, '').strip
        return nil unless valid_time_format?(time_parts)
        if time_parts =~ /(\d+)([dhms])/
            duration = time_parts.scan(/(\d+)([dhms])/)
            time = add_duration(time, duration)
            return format_time(time, 'at')
        end
        if time_parts =~ /^\d{4}\/\d{1,2}\/\d{1,2} \d{1,2}:\d{2}:\d{2}/
            return format_time(Time.parse(time_parts), 'at')
        elsif time_parts =~ /^\d{1,2}:\d{2}(:\d{2})?$/
            time = Time.parse("#{time.strftime('%Y/%m/%d')} #{time_parts}")
            return format_time(time, 'at')
        end
        return nil
    end

    def self.valid_time_format?(time_parts)
        time_parts =~ /^\d{4}\/\d{1,2}\/\d{1,2} \d{1,2}:\d{2}:\d{2}$/ ||
        time_parts =~ /^\d{1,2}:\d{2}(:\d{2})?$/ ||
        time_parts =~ /(\d+)([dhms])/
    end

    def self.format_time(time, preposition) = { preposition: preposition, time: time.strftime('%Y/%m/%d %H:%M:%S') }
end
