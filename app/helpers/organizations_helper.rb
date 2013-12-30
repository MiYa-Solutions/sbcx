module OrganizationsHelper
  def industry_options
    Organization.industries.map { |industry| [Organization.human_industry_name(industry), industry.to_s] }
  end

end
