class StylingService
  include Singleton


  def initialize
    @styles = {}
    Dir[Rails.root.join('config', 'styling', '**/*.yml').to_s].each do |file|
      @styles = @styles.merge (YAML.load File.open(file))
    end
  end


  def get_style(path)
    initialize if Rails.env == "development"
    res = @styles
    path.split(".").each do |key|
      unless res[key]
        res = ''
        break
      end
      res = res[key]
    end
    res
  end

end
