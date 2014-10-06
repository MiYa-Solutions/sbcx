module Forms::InvoiceForm
  attr_accessor :adv_payment_amount
  attr_accessor :adv_payment_desc
  attr_accessor :email_customer

  def self.included(base)
    base.before_create :generate_adv_payment, unless: -> { adv_payment_amount.blank? }
    base.validates_numericality_of :adv_payment_amount, allow_blank: true
    base.validates_presence_of :adv_payment_desc, unless: -> { adv_payment_amount.blank? }
    base.validate :email_presence, unless: -> { email_customer.blank? || email_customer == '0' }
  end

  private
  def generate_adv_payment
    entry = AdvancePayment.new(amount:      adv_payment_amount,
                               description: adv_payment_desc, ticket: self.ticket)
    self.account.entries << entry
    #self.adv_payment_items << entry
    entry.valid?
  end

  def email_presence
    self.errors.add :email_customer, 'The customer does not have an email specified' if ticket.customer.email.blank?
    self.errors.add :email_customer, 'You must have an email specified in your organization to be able to send emails' if organization.email.blank?
  end

end