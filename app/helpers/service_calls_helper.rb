module ServiceCallsHelper



  def style(path)
    StylingService.instance.get_style(path)
  end


  ServiceCall.state_machine(:work_status).events.map(&:name).each do |event|
    define_method("work_#{event}_form") do |service_call|
      simple_form_for service_call.becomes(ServiceCall), html: {class: style("service_call.forms.work_status.#{event}.form_classes")} do |f|
        concat (hidden_field_tag "service_call[work_status_event]", "#{event}")
        concat (f.submit service_call.class.human_work_status_event_name(event).titleize,
                         id:    "#{event}_service_call_btn",
                         class: style("service_call.forms.work_status.#{event}.button_classes"),
                         title: I18n.t("service_call.forms.work_status.#{event}.tooltip"),
                         rel:   'tooltip'
               )
      end
    end
  end

  ServiceCall.state_machine(:subcontractor_status).events.map(&:name).each do |event|
    define_method("subcon_#{event}_form") do |service_call|
      simple_form_for service_call.becomes(ServiceCall), html: {class: style("service_call.forms.work_status.#{event}.form_classes")}  do |f|
        concat (hidden_field_tag "service_call[subcontractor_status_event]", "#{event}")
        concat (f.submit service_call.class.human_subcontractor_status_event_name(event).titleize,
                         id:    "#{event}_service_call_btn",
                         class: style("service_call.forms.subcontractor_status.#{event}.button_classes"),
                         title: I18n.t("service_call.forms.subcontractor_status.#{event}.tooltip"),
                         rel:   'tooltip'
               )
      end
    end
  end

  TransferredServiceCall.state_machine(:provider_status).events.map(&:name).each do |event|
    define_method("provider_#{event}_form") do |service_call|
      simple_form_for service_call.becomes(ServiceCall), html: {class: style("service_call.forms.provider_status.#{event}.form_classes")} do |f|
        concat (hidden_field_tag "service_call[provider_status_event]", "#{event}")
        concat (f.submit service_call.class.human_provider_status_event_name(event).titleize,
                         id:    "#{event}_service_call_btn",
                         class: style("service_call.forms.provider_status.#{event}.button_classes"),
                         title: I18n.t("service_call.forms.provider_status.#{event}.tooltip"),
                         rel:   'tooltip'
               )
      end
    end
  end

  (TransferredServiceCall.state_machine(:status).events.map(&:name) | MyServiceCall.state_machine(:status).events.map(&:name)).each do |event|
    define_method("#{event}_form") do |service_call|
      simple_form_for service_call.becomes(ServiceCall), html: {class: style("service_call.forms.status.#{event}.form_classes")} do |f|
        concat (hidden_field_tag "service_call[status_event]", "#{event}")
        concat (f.submit service_call.class.human_status_event_name(event).titleize,
                         id:    "#{event}_service_call_btn",
                         class: StylingService.instance.get_style("service_call.forms.status.#{event}.button_classes"),
                         title: I18n.t("service_call.forms.status.#{event}.tooltip"),
                         rel:   'tooltip'
               )
      end
    end
  end

  (TransferredServiceCall.state_machine(:billing_status).events.map(&:name) | MyServiceCall.state_machine(:billing_status).events.map(&:name)).each do |event|
    define_method("billing_#{event}_form") do |service_call|
      simple_form_for service_call.becomes(ServiceCall), html: {class: style("service_call.forms.billing_status.#{event}.form_classes")} do |f|
        concat (hidden_field_tag "service_call[billing_status_event]", "#{event}")
        concat (f.submit service_call.class.human_billing_status_event_name(event).titleize,
                         id:    "#{event}_service_call_btn",
                         class: StylingService.instance.get_style("service_call.forms.billing_status.#{event}.button_classes"),
                         title: I18n.t("service_call.forms.billing_status.#{event}.tooltip"),
                         rel:   'tooltip'
               )
      end
    end
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
      concat(content_tag :li, send("#{event}_form".to_sym, service_call))
    end
  end

  def work_status_forms(service_call)
    Rails.logger.debug { "ServiceCallsHelper: permitted to see work_status?: #{permitted_params(service_call).permitted_attribute?(:service_call, :work_status_event)}" }
    concat(content_tag :h3, t('headers.work_actions')) unless service_call.work_status_events.empty?
    service_call.work_status_events.collect do |event|
      concat(content_tag :li, send("work_#{event}_form".to_sym, service_call))
    end
  end

  def billing_status_forms(service_call)
    if service_call.allow_collection? || service_call.instance_of?(MyServiceCall)
      concat(content_tag :h3, t('headers.billing_actions')) unless service_call.billing_status_events.empty?
      service_call.billing_status_events.collect do |event|
        concat(content_tag :li, send("billing_#{event}_form".to_sym, service_call)) if permitted_params(service_call).permitted_attribute?(:service_call, :billing_status_event, event.to_s)
      end
    end

  end

  def subcontractor_status_forms(service_call)
    unless service_call.subcontractor_status_events.empty?
      concat(content_tag :h3, t('headers.subcontractor_actions')) unless service_call.subcontractor_status_events.empty?

      service_call.subcontractor_status_events.collect do |event|
        concat(content_tag :li, send("subcon_#{event}_form".to_sym, service_call))
      end
    end
  end

  def provider_status_forms(service_call)
    if service_call.instance_of?(TransferredServiceCall) && service_call.provider_settlement_allowed?
      concat(content_tag :h3, t('headers.provider_actions')) unless service_call.provider_status_events.empty?
      service_call.provider_status_events.collect do |event|
        concat(content_tag :li, send("provider_#{event}_form".to_sym, service_call))
      end
    end

  end

  ##
  # forms that require more than just a button are overridden  below
  #
  def work_dispatch_form(service_call)
    simple_form_for service_call.becomes(ServiceCall), html: {class: style("service_call.forms.work_status.dispatch.form_classes")} do |f|
      concat (f.input :technician_id, collection: f.object.organization.technicians, label_method: :name, value_method: :id)
      concat (hidden_field_tag "service_call[work_status_event]", 'dispatch')
      concat (f.submit service_call.class.human_work_status_event_name(:dispatch).titleize,
                       id:    'service_call_dispatch_btn',
                       class: "btn btn-large btn-primary",
                       title: 'Click to Dispatch the Service Call',
                       rel:   'tooltip'
             )
    end
  end

  def transfer_form(service_call)
    simple_form_for service_call.becomes(ServiceCall), html: {class: style("service_call.forms.status.transfer.form_classes")} do |f|
      concat (f.input :subcontractor_id, collection: f.object.organization.subcontractors, label_method: :name, value_method: :id )
      concat (f.input :allow_collection)
      concat (f.input :re_transfer)
      concat (hidden_field_tag "service_call[status_event]", 'transfer')
      concat (f.submit service_call.class.human_status_event_name(:transfer).titleize,
                       id:    'service_call_transfer_btn',
                       class: "btn btn-large btn-primary red-button",
                       title: 'Click to transfer the Service Call to the Subcontractor you selected',
                       rel:   'tooltip'
             )
    end
  end

  def billing_collect_form(service_call)
    simple_form_for service_call.becomes(ServiceCall), html: {class: style("service_call.forms.billing_status.collect.form_classes")} do |f|
      concat (hidden_field_tag "service_call[billing_status_event]", 'collect')
      concat (collector_tag(service_call))
      concat (f.submit service_call.class.human_billing_status_event_name(:collect).titleize,
                       id:    'collect_service_call_btn',
                       class: StylingService.instance.get_style("service_call.forms.billing_status.collect.button_classes"),
                       title: I18n.t("service_call.forms.billing_status.collect.tooltip"),
                       rel:   'tooltip'
             )
    end
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

  # todo collect to include payment type
  # todo payment form to include payment type
  #def paid_form(service_call)
  #  simple_form_for service_call.becomes(ServiceCall) do |f|
  #    concat (hidden_field_tag "service_call[billing_status_event]", 'paid')
  #    concat (hidden_field_tag "service_call[collector_id]", current_user.id)
  #    concat (f.submit service_call.class.human_billing_status_event_name(:paid).titleize,
  #                     id:    'settle_service_call_btn',
  #                     class: "btn btn-large",
  #                     title: 'Click to indicate that the customer has paid',
  #                     rel:   'tooltip'
  #           )
  #  end
  #end

  private

  def collector_tag(service_call)
    res = ""
    if service_call.organization.multi_user?
      res = select_tag("service_call[collector_id]", options_from_collection_for_select(service_call.organization.users, "id", "name"), include_blank: true)
    else
      res = hidden_field_tag("service_call[collector_id]", current_user.id)
    end
    res += hidden_field_tag("service_call[collector_type]", "User")
  end

end
