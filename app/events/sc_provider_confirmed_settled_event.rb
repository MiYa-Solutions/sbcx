class ScProviderConfirmedSettledEvent < ServiceCallEvent

    def init
        self.name         = I18n.t('service_call_provider_confirmed_settled_event.name')
        self.description  = I18n.t('service_call_provider_confirmed_settled_event.description')
        self.reference_id = 100031
    end

    def notification_recipients
        User.my_admins(service_call.organization_id)
    end

    def notification_class
        ScProviderConfirmedSettledNotification
    end
  def process_event
    service_call.provider_confirmed_provider
    super
  end

end
