class ScConfirmSettledProviderEvent < ServiceCallEvent

    def init
        self.name         = I18n.t('service_call_confirm_settled_event.name')
        self.description  = I18n.t('service_call_confirm_settled_event.description')
        self.reference_id = 100032
    end

    def notification_recipients
        nil
    end

    def notification_class
        nil
    end

    def update_provider
        prov_service_call.events << ScSubconConfirmedSettledEvent.new(triggering_event: self)
    end


end
