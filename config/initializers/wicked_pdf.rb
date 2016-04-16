WickedPdf.config do |config|
  if Rails.env == 'production' then
    config.exe_path = Rails.root.to_s + "/bin/wkhtmltopdf"
  else  ### Following allows for development on my MacBook or Linux box
    if /darwin/ =~ RUBY_PLATFORM then
      config.exe_path = "#{ENV['GEM_HOME']}/wkhtmltopdf-binary-0.9.9.3/bin/wkhtmltopdf"
    elsif /linux/ =~ RUBY_PLATFORM then
      config.exe_path = '/usr/bin/wkhtmltopdf'
    else
      raise "UnableToLocateWkhtmltopdf"
    end
  end
end