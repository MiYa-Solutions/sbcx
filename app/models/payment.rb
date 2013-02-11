class Payment < ActiveRecord::Base
  belongs_to :agreement

  validates_uniqueness_of :agreement_id, scope: [:type]

  def self.new_payment(type, agreement_id)
    unless type.nil?
      payment              = type.classify.constantize.new
      payment.agreement_id = agreement_id
    end

    raise "the 'type' parameter was not provided when creating a new payment type" if payment.nil?
    payment

  end

  def self.new_payment_from_params(type, params)
    unless type.nil?
      payment = type.classify.constantize.new(params)
    end

    raise "the 'type' parameter was not provided when creating a new posting rule" if payment.nil?
    payment

  end
end
