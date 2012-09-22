module ServiceCallsHelper
  def event_list(service_call)
    content_tag_for :ul, service_call, class: 'service_call_events' do

      service_call.status_events.collect do |event|

        case event
          when :transfer
            concat (content_tag :li, transfer_form(service_call))
          when :dispatch
            concat (content_tag :li, dispatch_form(service_call))
          when :start
            concat (content_tag :li, start_form(service_call))
          when :complete
            concat (content_tag :li, complete_form(service_call))
          when :settle
            concat (content_tag :li, settle_form(service_call))
          else
            concat(content_tag :li, ServiceCall.human_status_event_name(event))
        end
      end

    end
  end

  def settle_form(service_call)
    simple_form_for service_call do |f|
      concat (hidden_field_tag :status_event, 'settle')
      concat (f.submit ServiceCall.human_status_event_name(:settle).titleize)
    end
  end

  def complete_form(service_call)
    simple_form_for service_call do |f|
      concat (hidden_field_tag :status_event, 'complete')
      concat (f.submit ServiceCall.human_status_event_name(:complete).titleize)
    end
  end

  def start_form(service_call)
    simple_form_for service_call do |f|
      concat (hidden_field_tag :status_event, 'start')
      concat (f.submit ServiceCall.human_status_event_name(:start).titleize)
    end
  end

  def dispatch_form(service_call)
    simple_form_for service_call do |f|
      concat (f.input :technician, collection: f.object.organization.technicians, label_method: :name, value_method: :id)
      concat (hidden_field_tag :status_event, 'dispatch')
      concat (f.submit ServiceCall.human_status_event_name(:dispatch).titleize)
    end
  end

  def transfer_form(service_call)
    simple_form_for service_call do |f|
      concat (f.input :subcontractor, collection: f.object.organization.subcontractors, label_method: :name, value_method: :id)
      concat (hidden_field_tag :status_event, 'transfer')
      concat (f.submit ServiceCall.human_status_event_name(:transfer).titleize)
    end
  end

end
