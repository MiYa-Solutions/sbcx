module ProjectsHelper
  def local_provider_options
    res = []
    @org.providers.where(subcontrax_member: nil).each do |prov|
      res << [prov.name, prov.id, { "data-agreements" => agreement_data_tags(prov, current_user.organization) }]
    end

    # res << [current_user.organization.name, current_user.organization_id]

    res

  end
end
