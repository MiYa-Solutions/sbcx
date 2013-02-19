class ScProviderCollectedNotification < ServiceCallNotification

    def html_message
        I18n.t('notifications.sc_provider_collected_notification.html_message', provider: service_call.subcontractor.name, link: service_call_link, ref: service_call.ref_id).html_safe
    end

    def default_subject
        I18n.t('notifications.sc_provider_collected_notification.subject', ref: service_call.ref_id)
    end

    def default_content
        I18n.t('notifications.sc_provider_collected_notification.content', provider: service_call.subcontractor.name, ref: service_call.ref_id)
    end


end
