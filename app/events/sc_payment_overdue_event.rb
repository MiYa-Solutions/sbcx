class ScPaymentOverdueEvent < ServiceCallEvent

    def init
        self.name         = I18n.t('service_call_payment_overdue_event.name')
        self.description  = I18n.t('service_call_payment_overdue_event.description')
        self.reference_id = 100028
    end

    def notification_recipients
        nil
    end

    def notification_class
        nil
    end

end
