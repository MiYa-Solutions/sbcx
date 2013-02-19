class ScDepositEvent < ServiceCallEvent

    def init
        self.name         = I18n.t('service_call_deposit_event.name')
        self.description  = I18n.t('service_call_deposit_event.description', provider: service_call.provider.name)
        self.reference_id = 100022
    end

    def notification_recipients
        nil
    end

    def notification_class
        nil
    end

    def update_provider
        prov_service_call.events << ScSubconDepositedEvent.new(triggering_event: self)
    end


end
