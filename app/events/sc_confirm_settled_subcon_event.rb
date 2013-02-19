class ScConfirmSettledSubconEvent < ServiceCallEvent

    def init
        self.name         = I18n.t('service_call_confirm_settled_event.name')
        self.description  = I18n.t('service_call_confirm_settled_event.description')
        self.reference_id = 100033
    end

    def notification_recipients
        nil
    end

    def notification_class
        nil
    end

    def update_subcontractor
        subcon_service_call.events << ScProviderConfirmedSettledEvent.new(triggering_event: self)
    end


end
