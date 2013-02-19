class ScConfirmDepositEvent < ServiceCallEvent

    def init
        self.name         = I18n.t('service_call_confirm_deposit_event.name')
        self.description  = I18n.t('service_call_confirm_deposit_event.description', subcontractor: service_call.subcontractor.name)
        self.reference_id = 100025
    end

    def notification_recipients
        nil
    end

    def notification_class
        ScConfirmDepositNotification
    end

    def update_subcontractor
        subcon_service_call.events << ScDepositConfirmedEvent.new(triggering_event: self)
    end


end
