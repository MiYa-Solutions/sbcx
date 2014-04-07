# == Schema Information
#
# Table name: tickets
#
#  id                       :integer          not null, primary key
#  customer_id              :integer
#  notes                    :text
#  started_on               :datetime
#  organization_id          :integer
#  completed_on             :datetime
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  status                   :integer
#  subcontractor_id         :integer
#  technician_id            :integer
#  provider_id              :integer
#  subcontractor_status     :integer
#  type                     :string(255)
#  ref_id                   :integer
#  creator_id               :integer
#  updater_id               :integer
#  settled_on               :datetime
#  billing_status           :integer
#  settlement_date          :datetime
#  name                     :string(255)
#  scheduled_for            :datetime
#  transferable             :boolean          default(TRUE)
#  allow_collection         :boolean          default(TRUE)
#  collector_id             :integer
#  collector_type           :string(255)
#  provider_status          :integer
#  work_status              :integer
#  re_transfer              :boolean          default(TRUE)
#  payment_type             :string(255)
#  subcon_payment           :string(255)
#  provider_payment         :string(255)
#  company                  :string(255)
#  address1                 :string(255)
#  address2                 :string(255)
#  city                     :string(255)
#  state                    :string(255)
#  zip                      :string(255)
#  country                  :string(255)
#  phone                    :string(255)
#  mobile_phone             :string(255)
#  work_phone               :string(255)
#  email                    :string(255)
#  subcon_agreement_id      :integer
#  provider_agreement_id    :integer
#  tax                      :float            default(0.0)
#  subcon_fee_cents         :integer          default(0), not null
#  subcon_fee_currency      :string(255)      default("USD"), not null
#  properties               :hstore
#  external_ref             :string(255)
#  subcon_collection_status :integer
#  prov_collection_status   :integer
#

class TransferredServiceCall < ServiceCall
  validates_presence_of :provider, :provider_agreement
  validate :provider_is_not_a_member
  before_validation do
    self.subcontractor ||= self.organization.try(:becomes, Subcontractor)
  end

  after_create :set_ref_id

  STATUS_ACCEPTED = 1201
  STATUS_REJECTED = 1202

  state_machine :status, :initial => :new do
    state :new, value: STATUS_NEW
    state :accepted, value: STATUS_ACCEPTED
    state :rejected, value: STATUS_REJECTED
    state :transferred, value: STATUS_TRANSFERRED do
      validate { |sc| sc.validate_subcon }
    end
    state :closed, value: STATUS_CLOSED
    state :canceled, value: STATUS_CANCELED

    before_transition any => :transferred do |sc, transition|
      sc.type = 'BrokerServiceCall'
    end

    after_failure do |service_call, transition|
      Rails.logger.debug { "Transferred Service Call status state machine failure. Service Call errors : \n" + service_call.errors.messages.inspect + "\n The transition: " +transition.inspect }
    end

    event :accept do
      transition :new => :accepted
    end

    # todo reinstate once we decide to implement the un_accept event
    #event :un_accept do
    #  transition :accepted => :rejected, unless: ->(sc) { sc.work_done? }
    #end

    event :reject do
      transition :new => :rejected
    end

    event :transfer do
      transition :accepted => :transferred, if: lambda { |sc| sc.work_pending? && sc.transferable? }
    end

    event :cancel_transfer do
      transition :transferred => :new, if: ->(sc) { !sc.work_done? }
    end

    event :cancel do
      transition [:accepted, :transferred] => :canceled
    end

    event :un_cancel do
      transition :canceled => :new, if: ->(sc) { sc.can_uncancel? }
    end


    event :close do
      transition :accepted => :closed, if: lambda { |sc| sc.work_done? && sc.provider_cleared? }
      transition :transferred => :closed, if: lambda { |sc| sc.work_done? && sc.provider_cleared? && sc.subcon_cleared? }
    end

  end

  state_machine :provider_status, :initial => :pending, namespace: 'provider' do
    state :pending, value: SUBCON_STATUS_PENDING
    state :cleared, value: SUBCON_STATUS_CLEARED
    state :claim_settled, value: SUBCON_STATUS_CLAIM_SETTLED do
      validates_presence_of :provider_payment
    end
    state :claimed_as_settled, value: SUBCON_STATUS_CLAIMED_AS_SETTLED do
      validates_presence_of :provider_payment
    end
    state :settled, value: SUBCON_STATUS_SETTLED do
      validates_presence_of :provider_payment
    end

    after_failure do |service_call, transition|
      Rails.logger.debug { "Service Call subcon status state machine failure. Service Call errors : \n" + service_call.errors.messages.inspect + "\n The transition: " +transition.inspect }
    end

    # for cash payment, paid means cleared
    after_transition any => :settled do |sc, transition|
      sc.provider_status = SUBCON_STATUS_CLEARED if sc.provider_payment == 'cash'
    end


    event :provider_confirmed do
      transition :claim_settled => :settled, if: lambda { |sc| sc.provider_settlement_allowed? }
    end

    event :provider_marked_as_settled do
      transition :pending => :claimed_as_settled, if: lambda { |sc| sc.provider_settlement_allowed? && sc.provider.subcontrax_member? }
    end

    event :confirm_settled do
      transition :claimed_as_settled => :settled, if: lambda { |sc| sc.provider_settlement_allowed? }
    end

    event :settle do
      transition :pending => :settled, if: lambda { |sc| sc.provider_settlement_allowed? && !sc.provider.subcontrax_member? }
      transition :pending => :claim_settled, if: lambda { |sc| sc.provider_settlement_allowed? && sc.provider.subcontrax_member? }
    end

    event :clear do
      transition :settled => :cleared
    end
  end

  state_machine :billing_status, initial: :na, namespace: 'payment' do
    state :na, value: 0

    event :collect do
      transition :na => :na, if: ->(sc) { sc.collection_allowed? }
    end
  end

  def collection_allowed?
    accepted? || transferred?
  end

  def payments
    if provider.member?
      provider_ticket.payments
    else
      payment_entries
    end

  end

  def provider_ticket
    ServiceCall.where(organization_id: provider_id).where(ref_id: ref_id).first
  end

  def paid_amount
    Money.new(-(payment_entries.sum(:amount_cents) + payment_amount.to_f*100))
  end

  def payment_entries
    if provider.member?
      mixed_payment_entries
    else
      entries.where(type: CollectionEntry.subclasses.map(&:name))
    end
  end

  def provider_settlement_allowed?
    (allow_collection? && payment_deposited?) || (!allow_collection? && work_done?)
  end

  # to make the subcon_settlement_allowed? in ServiceCall work
  def payment_paid?
    payment_collected?
  end

  # to make the subcon_settlement_allowed? in ServiceCall work
  alias_method :payment_cleared?, :payment_paid?

  def payment_collected?
    payment_entries.sum(:amount_cents).abs > total.cents
  end

  def can_uncancel?
    !self.work_done? && !self.provider.subcontrax_member? &&
        ((self.subcontractor.present? && !self.subcontractor.subcontrax_member?) || self.subcontractor.nil?)
  end

  def my_profit
    income  = Money.new(IncomeFromProvider.where(ticket_id: self.id).sum(:amount_cents))
    payment = Money.new(PaymentToSubcontractor.where(ticket_id: self.id).sum(:amount_cents))
    income + payment # payment is expected to be a negative number

  end

  def validate_subcon
    super
    self.errors.add :subcontractor, I18n.t('activerecord.errors.ticket.circular_transfer') if self.validate_circular_transfer && self.status_changed? && self.status == ServiceCall::STATUS_TRANSFERRED
  end

  def check_and_set_as_fully_paid

  end

  private
  def provider_is_not_a_member
    if provider
      if provider_id != organization_id && provider.subcontrax_member && ServiceCall.find_by_ref_id_and_organization_id(ref_id, provider_id).nil?
        errors.add(:provider, I18n.t('service_call.errors.cant_create_for_member'))
      end
    else
      errors.add(:provider, I18n.t('service_call.errors.missing_provider'))

    end
    #if provider.subcontrax_member && ServiceCall.find_by_ref_id_and_organization_id(ref_id, provider_id).nil?
    #  errors.add(:provider, I18n.t('service_call.errors.cant_create_for_member'))
    #end
  end

  def set_ref_id
    unless self.read_attribute(:ref_id)
      self.ref_id = id
      self.save!
    end
  end

  def mixed_payment_entries
    collections    = entries.where(type: CollectionEntry.subclasses.map(&:name)).all
    collection_ids = collections.map(&:matching_entry_id).compact

    payments = provider_ticket.payments.reject { |payment| collection_ids.include?(payment.matching_entry_id) }

    EntryCollection.new(payments + collections)
  end


end
