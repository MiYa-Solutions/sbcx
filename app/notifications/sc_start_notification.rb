class ScStartNotification < ServiceCallNotification
  def html_message
    I18n.t('notifications.sc_start_notification.html_message', technician: service_call.technician.try(:name), link: service_call_link).html_safe
  end

  def default_subject
    I18n.t('notifications.sc_start_notification.subject', ref: service_call.ref_id)
  end

  def default_content

    I18n.t('notifications.sc_start_notification.content', started_at: service_call.started_on, technician: technician_name)
  end

  private

  def technician_name
    case service_call.my_role
      when :prov
        service_call.technician ? service_call.technician.name : service_call.subcontractor.name
      when :subcon
        service_call.technician.name
      when :broker
        service_call.subcontractor.name
      else
    end

  end

end