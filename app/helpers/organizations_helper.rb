module OrganizationsHelper
  def industry_options
    Organization.industries.map ->(industry) { [industry.to_s, Organization.human_industry_name(industry)] }
  end

end
