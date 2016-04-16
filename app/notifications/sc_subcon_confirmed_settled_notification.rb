class ScSubconConfirmedSettledNotification < ServiceCallNotification

    def html_message
        I18n.t('notifications.sc_subcon_confirmed_settled_notification.html_message', subcon: service_call.subcontractor.name, link: service_call_link).html_safe
    end

    def default_subject
        I18n.t('notifications.sc_subcon_confirmed_settled_notification.subject',subcon: service_call.subcontractor.name, ref: service_call.ref_id)
    end

    def default_content
        I18n.t('notifications.sc_subcon_confirmed_settled_notification.content', subcon: service_call.subcontractor.name, ref: service_call.ref_id)
    end


end
