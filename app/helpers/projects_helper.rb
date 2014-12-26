module ProjectsHelper
  def local_provider_options
    res = []
    @org.providers.where(subcontrax_member: nil).each do |prov|
      res << [prov.name, prov.id, { "data-agreements" => agreement_data_tags(prov, current_user.organization) }]
    end

    # res << [I18n.t('general.general.empty'), -1]

    res

  end

  def provider_filter_options
    options_from_collection_for_select(current_user.organization.providers, 'id', 'name') +
        "<option style='strong' value='-1'>#{I18n.t('general.general.empty')}<option>".html_safe
  end

  def new_project_job_path(proj)
    job_params = {service_call: {}}
    job_params[:service_call].merge!(project_id: proj.id)
    job_params[:service_call].merge!(provider_id: proj.provider_id) if proj.provider_id
    job_params[:service_call].merge!(provider_agreement_id: proj.provider_agreement_id) if proj.provider_agreement_id
    job_params[:service_call].merge!(customer_id: proj.customer_id) if proj.customer_id
    job_params[:service_call].merge!(external_ref: proj.external_ref) if proj.external_ref
    new_service_call_path(job_params)
  end

  def project_statuses
    Project.state_machines[:status].states.map &:human_name
  end

end
