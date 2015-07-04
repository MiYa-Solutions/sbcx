class OrgSettings
  extend ActiveModel::Naming
  extend ActiveModel::Translation
  include ActiveModel::Conversion
  include ActiveModel::Validations


  def self.number_fields
    [:default_tax]
  end

  def self.boolean_fields
    [:validate_job_ext_ref, :external_ref_unique]
  end

  def self.fields
    self.number_fields + boolean_fields
  end

  self.number_fields.each do |key|
    define_method(key) do
      org.properties && (org.properties[key.to_s] || org.properties[key])
    end

    define_method("#{key}=") do |value|
      org.properties = (org.properties || {}).merge(key => value)
    end
  end

  self.boolean_fields.each do |key|
    define_method(key) do
      org.properties && org.properties[key.to_s] &&
          ((org.properties[key.to_s] == '1' || org.properties[key.to_s] == true || org.properties[key.to_s] == 'true') ||
              (org.properties[key] == '1' || org.properties[key] == true || org.properties[key] == 'true'))
    end

    alias_method "#{key}?", key

    define_method("#{key}=") do |value|
      org.properties = (org.properties || {}).merge(key => value)
    end
  end

  validates_numericality_of :default_tax, allow_blank: true

  def initialize(org)
    @org = org
  end

  def save(params)
    save_org_settings(params)
  end

  def persisted?
    false
  end

  private

  def org
    @org
  end

  def save_org_settings(params)
    serialize_settings(params)
    @org.save if self.valid?
  end

  def serialize_settings(params)
    params.each do |key, value|
      @org.properties = (@org.properties || {}).merge(key => value)
    end

  end

end