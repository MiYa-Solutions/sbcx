class ActiveSupport::BufferedLogger
  def formatter=(formatter)
    @log.formatter = formatter
  end
end

class Formatter
  SEVERITY_TO_TAG_MAP = {'DEBUG' => 'DEBUG', 'INFO' => 'FYI', 'WARN' => 'WARNING', 'ERROR' => 'WTF', 'FATAL' => 'FATAL', 'UNKNOWN' => '???'}
  SEVERITY_TO_COLOR_MAP = {'DEBUG' => '35', 'INFO' => '32', 'WARN' => '33', 'ERROR' => '31', 'FATAL' => '31', 'UNKNOWN' => '37'}
  USE_HUMOROUS_SEVERITIES = false

  def call(severity, time, progname, msg)
    if USE_HUMOROUS_SEVERITIES
      formatted_severity = sprintf("%-3s", "#{SEVERITY_TO_TAG_MAP[severity]}")
    else
      formatted_severity = sprintf("%-5s", "#{severity}")
    end

    formatted_time = time.strftime("%Y-%m-%d %H:%M:%S.") << time.usec.to_s[0..2].rjust(3)
    color = SEVERITY_TO_COLOR_MAP[severity]

    if severity == 'DEBUG'
      msg_color = color
    end

    "\033[0;37m#{formatted_time}\033[0m [\033[#{color}m#{formatted_severity}\033[0m] [\033[#{msg_color}m#{msg.strip} (pid:#{$$})\n"
  end

end

Rails.logger.formatter = Formatter.new