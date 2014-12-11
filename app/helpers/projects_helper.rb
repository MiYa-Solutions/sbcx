module ProjectsHelper
  def local_provider_options
    res = []
    @org.providers.where(subcontrax_member: nil).each do |prov|
      res << [prov.name, prov.id, { "data-agreements" => agreement_data_tags(prov, current_user.organization) }]
    end

    # res << [current_user.organization.name, current_user.organization_id]

    res

  end

  def new_project_job_path(proj)
    job_params = {service_call: {}}
    job_params[:service_call].merge!(project_id: proj.id)
    job_params[:service_call].merge!(provider_id: proj.provider_id) if proj.provider_id
    job_params[:service_call].merge!(provider_agreement_id: proj.provider_agreement_id) if proj.provider_agreement_id
    job_params[:service_call].merge!(customer_id: proj.customer_id) if proj.customer_id
    new_service_call_path(job_params)
  end
end
