module Forms::InvoiceForm
  attr_accessor :adv_payment_amount
  attr_accessor :adv_payment_desc
  attr_accessor :email_customer

  def self.included(base)
    base.before_create :generate_adv_payment, unless: -> { adv_payment_amount.blank? }
    base.validates_numericality_of :adv_payment_amount, allow_blank: true
    base.validates_presence_of :adv_payment_desc, unless: -> { adv_payment_amount.blank? }
  end

  private
  def generate_adv_payment
    entry = AdvancePayment.new(amount:      adv_payment_amount,
                               description: adv_payment_desc, ticket: self.ticket)
    self.account.entries << entry
    #self.adv_payment_items << entry
    entry.valid?
  end
end