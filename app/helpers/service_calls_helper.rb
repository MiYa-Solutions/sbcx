module ServiceCallsHelper
  include PaymentHelper

  def style(path)
    StylingService.instance.get_style(path)
  end


  def event_list(service_call)
    content_tag_for :ul, service_call, class: 'service_call_events unstyled' do
      status_forms(service_call) if permitted_params(service_call).permitted_attribute?(:service_call, :status_event)
      work_status_forms(service_call) if permitted_params(service_call).permitted_attribute?(:service_call, :work_status_event)
      billing_status_forms(service_call) if permitted_params(service_call).permitted_attribute?(:service_call, :billing_status_event)
      subcontractor_status_forms(service_call) if permitted_params(service_call).permitted_attribute?(:service_call, :subcontractor_status_event)
      provider_status_forms(service_call) if permitted_params(service_call).permitted_attribute?(:service_call, :provider_status_event)
    end
  end

  def status_forms(service_call)
    service_call.status_events.collect do |event|
      #concat(content_tag :li, send("#{event}_form".to_sym, service_call))
      concat(render "service_calls/action_forms/status_forms/#{event}_form", job: service_call)
    end
  end

  def work_status_forms(service_call)
    #Rails.logger.debug { "ServiceCallsHelper: permitted to see work_status?: #{permitted_params(service_call).permitted_attribute?(:service_call, :work_status_event)}" }
    concat(content_tag :h3, t('headers.work_actions')) unless service_call.work_status_events.empty?
    service_call.work_status_events.collect do |event|
      #concat(content_tag :li, send("work_#{event}_form".to_sym, service_call))
      concat(render "service_calls/action_forms/work_status_forms/#{event}_form", job: service_call)
    end
  end

  def billing_status_forms(service_call)
    if service_call.allow_collection? || service_call.instance_of?(MyServiceCall)
      concat(content_tag :h3, t('headers.billing_actions')) unless service_call.billing_status_events.empty?
      service_call.billing_status_events.collect do |event|
        #concat(content_tag :li, send("billing_#{event}_form".to_sym, service_call)) if permitted_params(service_call).permitted_attribute?(:service_call, :billing_status_event, event.to_s)
        concat(render "service_calls/action_forms/billing_status_forms/#{event}_form", job: service_call)
      end
    end

  end

  def subcontractor_status_forms(service_call)
    unless service_call.subcontractor_status_events.empty?
      concat(content_tag :h3, t('headers.subcontractor_actions')) unless service_call.subcontractor_status_events.empty?

      service_call.subcontractor_status_events.collect do |event|
        #concat(content_tag :li, send("subcon_#{event}_form".to_sym, service_call)) if permitted_params(service_call).permitted_attribute?(:service_call, :subcontractor_status_event, event.to_s)
        concat(render "service_calls/action_forms/subcon_status_forms/#{event}_form", job: service_call)
      end
    end
  end

  def provider_status_forms(service_call)
    if service_call.instance_of?(TransferredServiceCall) && service_call.provider_settlement_allowed?
      concat(content_tag :h3, t('headers.provider_actions')) unless service_call.provider_status_events.empty?
      service_call.provider_status_events.collect do |event|
        #concat(content_tag :li, send("provider_#{event}_form".to_sym, service_call)) if permitted_params(service_call).permitted_attribute?(:service_call, :provider_status_event, event.to_s)
        concat(render "service_calls/action_forms/prov_status_forms/#{event}_form", job: service_call)
      end
    end

  end

  def subcon_transfer_props
    res_hash = {}
    # need to reload as the updated properties are not visible for some reason
    @service_call.reload.subcon_transfer_props.map do |props|
      klass = props.class
      props.attributes.map do |key, val|
        unless [:prov_bom_reimbursement, :provider_fee].include? key
          formatted_val = props.send(key)
          res_hash      = res_hash.merge klass.human_attribute_name(key) => formatted_val.instance_of?(Money) ? humanized_money_with_symbol(formatted_val) : formatted_val
        end
      end
    end
    res_hash
  end

  def provider_transfer_props
    res_hash = {}
    # need to reload as the updated properties are not visible for some reason
    @service_call.reload.provider_transfer_props.map do |props|
      klass = props.class
      props.attributes.map do |key, val|
        unless [:bom_reimbursement, :subcon_fee].include? key
          formatted_val = props.send(key)
          res_hash      = res_hash.merge klass.human_attribute_name(key) => formatted_val.instance_of?(Money) ? humanized_money_with_symbol(formatted_val) : formatted_val
        end
      end
    end
    res_hash
  end

  def technicians_collection
    @service_call.organization.technicians.map { |user| [user.id, user.name] }
  end

  def subcontractor_collection
    @service_call.organization.subcontractors.map { |subcon| [subcon.id, subcon.name] }
  end

# todo reject to inclulde also a rejection reason
#def work_reject_form(service_call)
#  simple_form_for service_call.becomes(ServiceCall) do |f|
#    concat (hidden_field_tag "service_call[work_status_event]", 'reject')
#    concat (f.submit service_call.class.human_work_status_event_name(:reject).titleize,
#                     id:    'reject_service_call_btn',
#                     class: "btn btn-large btn-danger",
#                     title: 'Click to reject this Service Call',
#                     rel:   'tooltip'
#           )
#  end
#end

  def subcon_options
    current_user.organization.subcontractors.collect do |subcon|
      [subcon.name, subcon.id, { "data-agreements" => agreement_data_tags(current_user.organization, subcon) }]
    end
  end

  def provider_options
    res = []
    current_user.organization.providers.each do |prov|
      res << [prov.name, prov.id, { "data-agreements" => agreement_data_tags(prov, current_user.organization) }]
    end

    res
  end


  private

  def agreement_data_tags(prov, subcon)
    h(SubcontractingAgreement.my_agreements(prov.id).cparty_agreements(subcon.id).with_status(:active).map { |agr| [agr.name, agr.id, agr.rules.first.try(:type)] })
  end

  def collector_tag(service_call)
    res = ""
    if service_call.organization.multi_user?
      res = select_tag("service_call[collector_id]", options_from_collection_for_select(service_call.organization.users, "id", "name"), include_blank: true)
    else
      res = hidden_field_tag("service_call[collector_id]", current_user.id)
    end
    res += hidden_field_tag("service_call[collector_type]", "User")
  end

  def payment_tag(job)

  end

end
