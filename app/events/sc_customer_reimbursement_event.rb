class ScCustomerReimbursementEvent < Event

  def init
    self.name         = I18n.t('sc_customer_reimbursement_event.name')
    self.description  = I18n.t('sc_customer_reimbursement_event.description')
    self.reference_id = 100048
  end

  def process_event
    CustomerBillingService.new(self).execute
  end

end
