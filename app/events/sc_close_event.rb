class ScCloseEvent < ServiceCallEvent

    def init
        self.name         = I18n.t('service_call_close_event.name')
        self.description  = I18n.t('service_call_close_event.description')
        self.reference_id = 100036
    end

    def notification_recipients
        nil
    end

    def notification_class
        nil
    end

end
