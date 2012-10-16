module ServiceCallsHelper
  def event_list(service_call)
    content_tag_for :ul, service_call, class: 'service_call_events' do

      service_call.status_events.collect do |event|
        case event
          when :transfer
            concat (content_tag :li, transfer_form(service_call))
          when :dispatch
            concat (content_tag :li, dispatch_form(service_call)) unless current_user.organization.users.count == 1
          when :start
            concat (content_tag :li, start_form(service_call))
          when :work_completed
            concat (content_tag :li, complete_form(service_call))
          when :settle
            concat (content_tag :li, settle_form(service_call))
          when :cancel_transfer
            concat (content_tag :li, cancel_transfer_form(service_call))
          when :reject
            concat (content_tag :li, reject_form(service_call))
          when :accept
            concat (content_tag :li, accept_form(service_call))
          when :paid
            concat (content_tag :li, paid_form(service_call))
          else
            concat(content_tag :li, service_call.class.human_status_event_name(event))
        end
      end

    end
  end

  def paid_form(service_call)
    simple_form_for service_call.becomes(ServiceCall) do |f|
      concat (hidden_field_tag "service_call[status_event]", 'paid')
      concat (f.input :total_price)
      concat (f.submit service_call.class.human_status_event_name(:paid).titleize, id: 'paid_service_call_btn')
    end
  end

  def accept_form(service_call)
    simple_form_for service_call.becomes(ServiceCall) do |f|
      concat (hidden_field_tag "service_call[status_event]", 'accept')
      concat (f.submit service_call.class.human_status_event_name(:accept).titleize, id: 'accept_service_call_btn')
    end
  end

  def reject_form(service_call)
    simple_form_for service_call.becomes(ServiceCall) do |f|
      concat (hidden_field_tag "service_call[status_event]", 'reject')
      concat (f.submit service_call.class.human_status_event_name(:reject).titleize, id: 'reject_service_call_btn')
    end
  end

  def cancel_transfer_form(service_call)
    simple_form_for service_call.becomes(ServiceCall) do |f|
      concat (hidden_field_tag "service_call[status_event]", 'cancel_transfer')
      concat (f.submit service_call.class.human_status_event_name(:cancel_transfer).titleize)
    end
  end

  def settle_form(service_call)
    simple_form_for service_call.becomes(ServiceCall) do |f|
      concat (hidden_field_tag "service_call[status_event]", 'settle')
      concat (f.submit service_call.class.human_status_event_name(:settle).titleize, id: 'settle_service_call_btn')
    end
  end

  def complete_form(service_call)
    simple_form_for service_call.becomes(ServiceCall) do |f|
      concat (hidden_field_tag "service_call[status_event]", 'work_completed')
      concat (f.submit service_call.class.human_status_event_name(:work_completed).titleize, id: 'complete_service_call_btn')
    end
  end

  def start_form(service_call)
    simple_form_for service_call.becomes(ServiceCall) do |f|
      concat (hidden_field_tag "service_call[status_event]", 'start')
      concat (f.submit service_call.class.human_status_event_name(:start).titleize, id: 'start_service_call_btn')
    end
  end

  def dispatch_form(service_call)
    simple_form_for service_call.becomes(ServiceCall) do |f|
      concat (f.input :technician_id, collection: f.object.organization.technicians, label_method: :name, value_method: :id)
      concat (hidden_field_tag "service_call[status_event]", 'dispatch')
      concat (f.submit service_call.class.human_status_event_name(:dispatch).titleize, id: 'service_call_dispatch_btn')
    end
  end

  def transfer_form(service_call)
    simple_form_for service_call.becomes(ServiceCall) do |f|
      concat (f.input :subcontractor_id, collection: f.object.organization.subcontractors, label_method: :name, value_method: :id)
      concat (hidden_field_tag "service_call[status_event]", 'transfer')
      concat (f.submit service_call.class.human_status_event_name(:transfer).titleize, id: 'service_call_transfer_btn')
    end
  end

end
