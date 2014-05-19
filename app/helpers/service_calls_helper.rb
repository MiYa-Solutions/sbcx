require 'abstract'
module ServiceCallsHelper
  include PaymentHelper

  def style(path)
    StylingService.instance.get_style(path)
  end


  def event_list(service_call)
    content_tag_for :div, service_call, class: 'service_call_events unstyled' do
      status_forms(service_call)
      work_status_forms(service_call)
      billing_status_forms(service_call)
      subcontractor_status_forms(service_call)
      provider_status_forms(service_call)
    end
  end

  def status_forms(service_call)
    if permitted_params(service_call).permitted_attribute?(:service_call, :status_event)
      JobStatusFormsRenderer.new(service_call, self).render
    end
  end

  def work_status_forms(service_call)
    if permitted_params(service_call).permitted_attribute?(:service_call, :work_status_event)
      #concat(content_tag :h3, t('headers.work_actions')) unless service_call.work_status_events.empty?
      service_call.work_status_events.collect do |event|
        #concat(content_tag :li, send("work_#{event}_form".to_sym, service_call))
        concat(render "service_calls/action_forms/work_status_forms/#{event}_form", job: service_call)
      end
    end
    ''
  end

  def billing_status_forms(service_call)
    if permitted_params(service_call).permitted_attribute?(:service_call, :billing_status_event)
      if service_call.allow_collection? || service_call.instance_of?(MyServiceCall)
        JobBillingFormsRenderer.new(service_call, self).render
      end
    end

  end

  def subcontractor_status_forms(service_call)
    if permitted_params(service_call).permitted_attribute?(:service_call, :subcontractor_status_event)
      unless service_call.subcontractor_status_events.empty?
        service_call.subcontractor_status_events.collect do |event|
          concat (render "service_calls/action_forms/subcon_status_forms/#{event}_form", job: service_call)
        end
      end
    end
    ''
  end

  def provider_status_forms(service_call)
    if permitted_params(service_call).permitted_attribute?(:service_call, :provider_status_event)
      if service_call.kind_of?(TransferredServiceCall) && service_call.provider_settlement_allowed?
        service_call.provider_status_events.collect do |event|
          if permitted_params(service_call).permitted_attribute?(:service_call, :provider_status_event, event.to_s)
            concat(render "service_calls/action_forms/prov_status_forms/#{event}_form", job: service_call)
          end
        end
      end
    end
    ''
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

  def billing_events_collection(job)
    events_collection(job, :billing_status, job.billing_status_events)
  end

  def collection_events(job)
    events_collection(job, :billing_status, [:collect])
  end

  def deposit_events(job)
    events_collection(job, :billing_status, [:deposit_to_prov, :subcon_deposited, :deposited, :employee_deposit])
  end


  private

  def events_collection(job, state_machine_name, event_mask = [])
    if event_mask.empty?
      events = job.send("#{state_machine_name}_events")
    else
      events = job.send("#{state_machine_name}_events").select { |val| event_mask.include? val }
    end

    events.map do |event|
      if permitted_params(job).permitted_attribute?('service_call', "#{state_machine_name}_event".to_sym, event.to_s)
        [
            #I18n.t("activerecord.state_machines.#{job.class.name.underscore}.#{state_machine_name}.events.#{event}"),
            job.class.send("human_#{state_machine_name}_event_name", event),
            event
        ]
      end
    end.compact
  end

  def agreement_data_tags(prov, subcon)
    h(SubcontractingAgreement.my_agreements(prov.id).cparty_agreements(subcon.id).with_status(:active).map { |agr| [agr.name, agr.id, agr.rules.first.try(:type)] })
  end

  def collector_tag(service_call)
    res = ''
    if service_call.available_payment_collectors.size > 1
      res = select_tag("service_call[collector_id]", options_from_collection_for_select(service_call.available_payment_collectors, "id", "name"), include_blank: true)
    else
      res = hidden_field_tag("service_call[collector_id]", current_user.organization.id)
    end
    res += hidden_field_tag("service_call[collector_type]", 'Organization')
  end

  def payment_tag(job)

  end


  class FormRenderer
    include Abstract

    def initialize(obj, view)
      @obj  = obj
      @view = view
    end

    def render
      rendered = []

      available_events.each do |event|
        # don't render the same form twice
        unless rendered.include? view_map[event]
          @view.concat(@view.render form_view_home_path + view_map[event], job: @obj)
          rendered << view_map[event]
        end
      end
      ''

    end


    abstract_methods :view_map, :available_events, :form_view_home_path

  end

  class JobStatusFormsRenderer < FormRenderer

    protected

    def form_view_home_path
      'service_calls/action_forms/status_forms/'
    end

    def view_map
      {
          cancel:          'cancel_form',
          un_cancel:       'un_cancel_form',
          accept:          'accept_form',
          un_accept:       'un_accept_form',
          reject:          'reject_form',
          transfer:        'transfer_form',
          close:           'close_form',
          cancel_transfer: 'cancel_transfer_form'
      }
    end

    protected
    def available_events
      @obj.status_events
    end

  end

  class JobBillingFormsRenderer < FormRenderer

    def render
      unless available_events.empty?
        #(@view.concat(@view.content_tag :h3, I18n.t('headers.billing_actions')))
        super
      end
    end

    protected

    def form_view_home_path
      'service_calls/action_forms/billing_status_forms/'
    end

    def view_map
      {
          clear:                  'clear_form',

          collect:                'collection_form',
          late:                   'overdue_form',
          provider_collected:     'collection_form',
          subcon_collected:       'collection_form',

          confirm_deposit:        'confirm_deposit_form',
          prov_confirmed_deposit: 'prov_confirmed_deposit_form',

          deposit_to_prov:        'deposit_form',
          subcon_deposited:       'deposit_form',
          deposited:              'deposit_form',
          employee_deposit:       'deposit_form',

          invoice:                'invoice_form',
          subcon_invoiced:        'invoice_form',
          provider_invoiced:      'invoice_form',

          paid:                   'paid_form',
          reject:                 'reject_form',
          overdue:                'overdue_form',
          reimburse:              'reimburse_form',
          mark_as_overpaid:       'overdue_form'

      }
    end

    def available_events
      @obj.billing_status_events.map { |event| event if @view.permitted_params(@obj).permitted_attribute?('service_call', :billing_status_event, event.to_s) }.compact
    end

  end

end
