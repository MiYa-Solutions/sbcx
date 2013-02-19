class ScSubconConfirmedSettledEvent < ServiceCallEvent

    def init
        self.name         = I18n.t('service_call_subcon_confirmed_settled_event.name')
        self.description  = I18n.t('service_call_subcon_confirmed_settled_event.description')
        self.reference_id = "CHANGE ME (AND DONT FORGET TO UPDATE THE EXCEL"
    end

    def notification_recipients
        nil
    end

    def notification_class
        ScSubconConfirmedSettledNotification
    end

    def update_provider
        # IF APPLICABLE ADD THE APPROPRIATE EVENT TO THE PROVIDER AND DELETE THIS COMMENT
        prov_service_call.events
    end


end
