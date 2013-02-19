class ScProviderSettleEvent < ServiceCallEvent

    def init
        self.name         = I18n.t('service_call_provider_settle_event.name')
        self.description  = I18n.t('service_call_provider_settle_event.description')
        self.reference_id = 100030
    end

    def notification_recipients
        nil
    end

    def notification_class
        nil
    end

    def update_provider
        prov_service_call.events << ScSubconSettledEvent.new(triggering_event: self)
    end


end
