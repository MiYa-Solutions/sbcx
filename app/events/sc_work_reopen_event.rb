class ScWorkReopenEvent < ServiceCallEvent

  def init
    self.name         = I18n.t('service_call_work_reopen_event.name')
    self.description  = I18n.t('service_call_work_reopen_event.description')
    self.reference_id = 100052
  end

  def notification_recipients
    nil
  end

  def notification_class
    ScWorkReopenNotification
  end

  def update_provider
  end

  def process_event
    # update the customer billing
    CustomerBillingService.new(self).execute
    # update the affiliates billing if one present
    AffiliateBillingService.new(self).execute if service_call.affiliate.present?

    update_customer_billing_status

  end

  private

  def update_customer_billing_status
    service_call.reopen_payment!
  end

end
