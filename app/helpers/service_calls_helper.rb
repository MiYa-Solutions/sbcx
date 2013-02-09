module ServiceCallsHelper
  def event_list(service_call)
    content_tag_for :ul, service_call, class: 'service_call_events unstyled' do
      status_forms(service_call)
      work_status_forms(service_call)
      billing_status_forms(service_call)
      subcontractor_status_forms(service_call)
      provider_status_forms(service_call)
    end
  end

  def status_forms(service_call)
    service_call.status_events.collect do |event|
      case event
        when :transfer
          concat (content_tag :li, transfer_form(service_call))
        #when :dispatch
        #  concat (content_tag :li, dispatch_form(service_call)) unless current_user.organization.users.count == 1
        #when :start
        #  concat (content_tag :li, start_form(service_call))
        #when :work_completed
        #  concat (content_tag :li, complete_form(service_call))
        #when :settle
        #  concat (content_tag :li, settle_form(service_call))
        when :accept
          concat (content_tag :li, accept_form(service_call))
        when :un_accept
          # todo
        when :reject
          concat (content_tag :li, reject_form(service_call))
        #when :paid
        #  concat (content_tag :li, paid_form(service_call))
        when :cancel_transfer
          concat (content_tag :li, cancel_transfer_form(service_call))
        when :cancel
          concat (content_tag :li, cancel_form(service_call))
        when :un_cancel
          concat (content_tag :li, un_cancel_form(service_call))
        when :close
          #todo
        else
          concat(content_tag :li, service_call.class.human_status_event_name(event))
      end
    end

  end

  def work_status_forms(service_call)
    Rails.logger.debug { "ServiceCallsHelper: permitted to see work_status?: #{permitted_params(service_call).permitted_attribute?(:service_call, :work_status_event)}" }
    if permitted_params(service_call).permitted_attribute?(:service_call, :work_status_event)
      concat(content_tag :h3, t('headers.work_actions')) unless service_call.work_status_events.empty?
      service_call.work_status_events.collect do |event|
        case event
          when :start
            concat (content_tag :li, work_start_form(service_call))
          when :accept
            concat (content_tag :li, work_accept_form(service_call))
          when :reject
            concat (content_tag :li, work_reject_form(service_call))
          when :dispatch
            concat (content_tag :li, work_dispatch_form(service_call))
          when :reset
            concat (content_tag :li, work_reset_form(service_call))
          when :complete
            concat (content_tag :li, work_complete_form(service_call))
          else
            concat(content_tag :li, service_call.class.human_work_status_event_name(event))
        end
      end
    end
  end

  def billing_status_forms(service_call)
    if service_call.allow_collection?
      concat(content_tag :h3, t('headers.billing_actions')) unless service_call.billing_status_events.empty?
      service_call.billing_status_events.collect do |event|
        case event

          when :invoice
            concat(content_tag :li, invoice_form(service_call))
          when :subcon_invoiced
            concat(content_tag :li, subcon_invoiced_form(service_call))
          when :collect
            # todo implement
          when :deposited
            # todo
          when :subcon_collected
            # todo
          when :subcon_deposited
            # todo
          when :confirm_deposit
            # todo
          when :deposit_to_prov
            # todo
          when :prov_confirmed_deposit
            # todo
          when :paid
            concat(content_tag :li, paid_form(service_call))
          when :overdue
            concat(content_tag :li, overdue_form(service_call))
          else
            concat(content_tag :li, service_call.class.human_billing_status_event_name(event))
        end
      end
    end

  end

  def subcontractor_status_forms(service_call)
    unless service_call.subcontractor.nil? || service_call.subcontractor.subcontrax_member?
      concat(content_tag :h3, t('headers.subcontractor_actions')) unless service_call.subcontractor_status_events.empty?
      service_call.subcontractor_status_events.collect do |event|
        case event
          when :start
            concat(content_tag :li, subcon_start_form(service_call))
          when :accept
            concat(content_tag :li, subcon_accept_form(service_call))
          when :reject
            concat(content_tag :li, subcon_reject_form(service_call))
          when :complete
            concat(content_tag :li, subcon_complete_form(service_call))
          when :settle
            # don't show a subcontractor settle button for a local subcontractor
          when :cancel
            # don't show a subcontractor cancel button for a local subcontractor
          when :transfer_again
            # don't allow a transfer again action for a local subcon
          else
            concat(content_tag :li, service_call.class.human_subcontractor_status_event_name(event))
        end
      end
    end
  end

  def provider_status_forms(service_call)

  end

  def work_accept_form(service_call)
    simple_form_for service_call.becomes(ServiceCall) do |f|
      concat (hidden_field_tag "service_call[work_status_event]", 'accept')
      concat (f.submit service_call.class.human_work_status_event_name(:accept).titleize,
                       id:    'accept_service_call_btn',
                       class: "btn btn-large btn-primary",
                       title: 'Click to indicate that you accept this Service Call',
                       rel:   'tooltip'
             )
    end
  end

  def accept_form(service_call)
    simple_form_for service_call.becomes(ServiceCall) do |f|
      concat (hidden_field_tag "service_call[status_event]", 'accept')
      concat (f.submit service_call.class.human_status_event_name(:accept).titleize,
                       id:    'accept_service_call_btn',
                       class: "btn btn-large btn-primary",
                       title: 'Click to indicate that you accept this Service Call',
                       rel:   'tooltip'
             )
    end
  end

  def un_cancel_form(service_call)
    simple_form_for service_call.becomes(ServiceCall) do |f|
      concat (hidden_field_tag "service_call[status_event]", 'un_cancel')
      concat (f.submit service_call.class.human_status_event_name(:un_cancel).titleize,
                       id:    'un_cancel_service_call_btn',
                       class: "btn btn-large btn-danger",
                       title: 'cancel this service call',
                       rel:   'tooltip'
             )
    end
  end

  def cancel_form(service_call)
    simple_form_for service_call.becomes(ServiceCall) do |f|
      concat (hidden_field_tag "service_call[status_event]", 'cancel')
      concat (f.submit service_call.class.human_status_event_name(:cancel).titleize,
                       id:    'cancel_service_call_btn',
                       class: "btn btn-large btn-danger",
                       title: 'cancel this service call',
                       rel:   'tooltip'
             )
    end
  end

  def reject_form(service_call)
    simple_form_for service_call.becomes(ServiceCall) do |f|
      concat (hidden_field_tag "service_call[status_event]", 'reject')
      concat (f.submit service_call.class.human_status_event_name(:reject).titleize,
                       id:    'reject_service_call_btn',
                       class: "btn btn-large btn-danger",
                       title: 'Click to reject this Service Call',
                       rel:   'tooltip'
             )
    end
  end

  def work_reject_form(service_call)
    simple_form_for service_call.becomes(ServiceCall) do |f|
      concat (hidden_field_tag "service_call[work_status_event]", 'reject')
      concat (f.submit service_call.class.human_work_status_event_name(:reject).titleize,
                       id:    'reject_service_call_btn',
                       class: "btn btn-large btn-danger",
                       title: 'Click to reject this Service Call',
                       rel:   'tooltip'
             )
    end
  end

  def settle_form(service_call)
    simple_form_for service_call.becomes(ServiceCall) do |f|
      concat (hidden_field_tag "service_call[status_event]", 'settle')
      concat (f.submit service_call.class.human_status_event_name(:settle).titleize,
                       id:    'settle_service_call_btn',
                       class: "btn btn-large",
                       title: 'Click to indicate that you have completed',
                       rel:   'tooltip'
             )
    end
  end

  def cancel_transfer_form(service_call)
    simple_form_for service_call.becomes(ServiceCall) do |f|
      concat (hidden_field_tag "service_call[status_event]", 'cancel_transfer')
      concat (f.submit service_call.class.human_status_event_name(:cancel_transfer).titleize,
                       class: "btn btn-large btn-danger",
                       title: 'Click if you wish to cancel transferring this Service Call to another Subcontractor',
                       rel:   'tooltip'
             )
    end
  end

  def complete_form(service_call)
    simple_form_for service_call.becomes(ServiceCall) do |f|
      concat (hidden_field_tag "service_call[status_event]", 'work_completed')
      concat (f.submit service_call.class.human_status_event_name(:work_completed).titleize,
                       id:    'complete_service_call_btn',
                       class: "btn btn-large btn-primary",
                       title: 'Click id work is completed',
                       rel:   'tooltip'
             )
    end
  end

  def work_start_form(service_call)
    simple_form_for service_call.becomes(ServiceCall) do |f|
      concat (hidden_field_tag "service_call[work_status_event]", 'start')
      concat (hidden_field_tag "service_call[technician_id]", service_call.technician_id ? service_call.technician_id : current_user.id)
      concat (f.submit service_call.class.human_work_status_event_name(:start).titleize,
                       id:    'start_service_call_btn',
                       class: "btn btn-large btn-primary",
                       title: 'Click to Start the Service Call',
                       rel:   'tooltip'
             )
    end
  end

  def work_reset_form(service_call)
    simple_form_for service_call.becomes(ServiceCall) do |f|
      concat (hidden_field_tag "service_call[work_status_event]", 'reset')
      concat (f.submit service_call.class.human_work_status_event_name(:reset).titleize,
                       id:    'start_service_call_btn',
                       class: "btn btn-large btn-primary",
                       title: 'Click to Start the Service Call',
                       rel:   'tooltip'
             )
    end
  end

  def work_complete_form(service_call)
    simple_form_for service_call.becomes(ServiceCall) do |f|
      concat (hidden_field_tag "service_call[work_status_event]", 'complete')
      concat (f.submit service_call.class.human_work_status_event_name(:complete).titleize,
                       id:    'complete_service_call_btn',
                       class: "btn btn-large btn-primary",
                       title: 'Click to Start the Service Call',
                       rel:   'tooltip'
             )
    end
  end

  def work_dispatch_form(service_call)
    simple_form_for service_call.becomes(ServiceCall) do |f|
      concat (f.input :technician_id, collection: f.object.organization.technicians, label_method: :name, value_method: :id)
      concat (hidden_field_tag "service_call[work_status_event]", 'dispatch')
      concat (f.submit service_call.class.human_work_status_event_name(:dispatch).titleize,
                       id:    'service_call_dispatch_btn',
                       class: "btn btn-large",
                       title: 'Click to Dispatch the Service Call',
                       rel:   'tooltip'
             )
    end
  end

  def transfer_form(service_call)
    simple_form_for service_call.becomes(ServiceCall) do |f|
      concat (f.input :subcontractor_id, collection: f.object.organization.subcontractors, label_method: :name, value_method: :id)
      concat (f.input :allow_collection)
      concat (f.input :re_transfer)
      concat (hidden_field_tag "service_call[status_event]", 'transfer')
      concat (f.submit service_call.class.human_status_event_name(:transfer).titleize,
                       id:    'service_call_transfer_btn',
                       class: "btn btn-large",
                       title: 'Click to transfer the Service Call to the Subcontractor you selected',
                       rel:   'tooltip'
             )
    end
  end

  def invoice_form(service_call)
    simple_form_for service_call.becomes(ServiceCall) do |f|
      concat (hidden_field_tag "service_call[billing_status_event]", 'invoice')
      concat (f.submit service_call.class.human_billing_status_event_name(:invoice).titleize,
                       id:    'invoice_service_call_btn',
                       class: "btn btn-large",
                       title: 'Click to indicate that you have presented the invoice to the client - note you will not be able to add or remove parts after you invoice the customer',
                       rel:   'tooltip'
             )
    end
  end

  def paid_form(service_call)
    simple_form_for service_call.becomes(ServiceCall) do |f|
      concat (hidden_field_tag "service_call[billing_status_event]", 'paid')
      concat (hidden_field_tag "service_call[collector_id]", current_user.id)
      concat (f.submit service_call.class.human_billing_status_event_name(:paid).titleize,
                       id:    'settle_service_call_btn',
                       class: "btn btn-large",
                       title: 'Click to indicate that the customer has paid',
                       rel:   'tooltip'
             )
    end
  end

  def subcon_invoiced_form(service_call)
    simple_form_for service_call.becomes(ServiceCall) do |f|
      concat (hidden_field_tag "service_call[billing_status_event]", 'subcon_invoiced')
      concat (f.submit service_call.class.human_billing_status_event_name(:subcon_invoiced).titleize,
                       id:    'settle_service_call_btn',
                       class: "btn btn-large",
                       title: 'Click to indicate that the subcontractor provided an invoice to the client',
                       rel:   'tooltip'
             )
    end
  end

  def collect_form(service_call)
    simple_form_for service_call.becomes(ServiceCall) do |f|
      concat (hidden_field_tag "service_call[billing_status_event]", 'collect')
      concat (collector_tag(service_call))
      concat (f.submit service_call.class.human_billing_status_event_name(:collect).titleize,
                       id:    'settle_service_call_btn',
                       class: "btn btn-large",
                       title: 'Click to indicate that the payment was collected',
                       rel:   'tooltip'
             )
    end
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

  def overdue_form(service_call)
    simple_form_for service_call.becomes(ServiceCall) do |f|
      concat (hidden_field_tag "service_call[billing_status_event]", 'overdue')
      concat (f.submit service_call.class.human_billing_status_event_name(:overdue).titleize,
                       id:    'settle_service_call_btn',
                       class: "btn btn-large",
                       title: 'Click to indicate that the customer payment for this service call is overdue',
                       rel:   'tooltip'
             )
    end
  end

  def subcon_start_form(service_call)
    simple_form_for service_call.becomes(ServiceCall) do |f|
      concat (hidden_field_tag "service_call[subcontractor_status_event]", 'start')
      concat (f.submit service_call.class.human_subcontractor_status_event_name(:start).titleize,
                       id:    'start_service_call_btn',
                       class: "btn btn-large btn-primary",
                       title: 'Click to Start the Service Call',
                       rel:   'tooltip'
             )
    end

  end

  def subcon_accept_form(service_call)
    simple_form_for service_call.becomes(ServiceCall) do |f|
      concat (hidden_field_tag "service_call[subcontractor_status_event]", 'accept')
      concat (f.submit service_call.class.human_subcontractor_status_event_name(:accept).titleize,
                       id:    'accept_service_call_btn',
                       class: "btn btn-large btn-primary",
                       title: 'Click to indicate that the subcontractor accepted this Service Call',
                       rel:   'tooltip'
             )
    end
  end

  def subcon_reject_form(service_call)
    simple_form_for service_call.becomes(ServiceCall) do |f|
      concat (hidden_field_tag "service_call[subcontractor_status_event]", 'reject')
      concat (f.submit service_call.class.human_subcontractor_status_event_name(:reject).titleize,
                       id:    'reject_service_call_btn',
                       class: "btn btn-large btn-danger",
                       title: 'Click to reject this Service Call',
                       rel:   'tooltip'
             )
    end
  end

  def subcon_complete_form(service_call)
    simple_form_for service_call.becomes(ServiceCall) do |f|
      concat (hidden_field_tag "service_call[subcontractor_status_event]", 'complete')
      concat (f.submit service_call.class.human_subcontractor_status_event_name(:complete).titleize,
                       id:    'complete_service_call_btn',
                       class: "btn btn-large btn-primary",
                       title: 'Click id work is completed',
                       rel:   'tooltip'
             )
    end
  end
end
