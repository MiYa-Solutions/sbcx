class ActiveSupport::BufferedLogger
  def formatter=(formatter)
    @log.formatter = formatter
  end
end

class Formatter
  SEVERITY_TO_TAG_MAP     = { 'DEBUG' => 'DEBUG', 'INFO' => 'FYI', 'WARN' => 'WARNING', 'ERROR' => 'WTF', 'FATAL' => 'FATAL', 'UNKNOWN' => 'UNKNOWN' }
  SEVERITY_TO_COLOR_MAP   = { 'DEBUG' => '35', 'INFO' => '32', 'WARN' => '33', 'ERROR' => '31', 'FATAL' => '31', 'UNKNOWN' => '37' }
  USE_HUMOROUS_SEVERITIES = false

  def call(severity, time, progname, msg)

    # Formatting Attribute codes:
    # example: "\033[1;31;43m Hello \033[0;33;42m World" will print hello in bold red font with yellow background
    #          and World will be printed in a regular yellow text with green background
    # 00=none 01=bold 04=underscore 05=blink 07=reverse 08=concealed
    # Text color codes:
    # 30=black 31=red 32=green 33=yellow 34=blue 35=magenta 36=cyan 37=white
    # Background color codes:
    # 40=black 41=red 42=green 43=yellow 44=blue 45=magenta 46=cyan 47=white

    if USE_HUMOROUS_SEVERITIES
      formatted_severity = sprintf("%-3s", "#{SEVERITY_TO_TAG_MAP[severity]}")
    else
      formatted_severity = sprintf("%-5s", "#{severity}")
    end

    formatted_time = time.strftime("%Y-%m-%d %H:%M:%S.") << time.usec.to_s[0..2].rjust(3)
    color          = SEVERITY_TO_COLOR_MAP[severity]

    if severity == 'DEBUG'
      msg_color = color
    end

    formatted_msg = format_msg(msg)

    if Rails.env == "development"
      result = "[\033[#{color}m#{formatted_severity}\033[0m] [\033[#{msg_color}m#{formatted_msg} (pid:#{$$})\n"
    else
      result = "\033[0m#{formatted_time}\033[0m [\033[#{color}m#{formatted_severity}\033[0m] [\033[#{msg_color}m#{msg.strip} (pid:#{$$})\n"
    end
    result
  end

  def format_msg(msg)
    formatted_msg = msg.strip
    formatted_msg = formatted_msg.sub /Started/, "\033[42;33mStarted"
    formatted_msg = formatted_msg.sub /Completed/, "\033[44;37mCompleted"
    "#{formatted_msg}\033[0m"
  end

end

Rails.logger.formatter = Formatter.new

if Rails.env == "development" || Rails.env == "test"
  Dir.glob("#{Rails.root}/app/notifications/*.rb").sort.each { |file| require_dependency file }
  Dir.glob("#{Rails.root}/app/events/*.rb").sort.each { |file| require_dependency file }
  Dir.glob("#{Rails.root}/app/models/payments/*.rb").sort.each { |file| require_dependency file }
  Dir.glob("#{Rails.root}/app/models/accounting_entries/*.rb").sort.each { |file| require_dependency file }
end

