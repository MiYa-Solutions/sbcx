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

class MyServiceCall < ServiceCall
  include CustomerJobBilling
  include CollectionStateMachine

  collection_status :subcon_collection_status, initial: :na, namespace: 'subcon_collection'

  alias_method :can_subcon_deposited_subcon_collection?, :can_deposited_subcon_collection?

  before_validation do
    self.provider = self.organization.becomes(Provider) if self.organization
  end

  after_create :set_ref_id

  state_machine :status, :initial => :new do

    state :new, value: STATUS_NEW
    state :open, value: STATUS_OPEN do
      validate { |sc| sc.validate_technician }
    end
    state :transferred, value: STATUS_TRANSFERRED do
      validate { |sc| sc.validate_subcon }
      validates_presence_of :subcon_agreement_id
    end
    state :closed, value: STATUS_CLOSED
    state :canceled, value: STATUS_CANCELED

    after_failure do |service_call, transition|
      Rails.logger.debug { "My Service Call status state machine failure. Service Call errors : \n" + service_call.errors.messages.inspect + "\n The transition: " +transition.inspect }
    end

    event :activate do
      transition :new => :open, if: lambda { |sc| sc.work_in_progress? || sc.work_dispatched? }
    end

    event :transfer do
      transition :new => :transferred
      transition :open => :transferred, unless: ->(sc) { sc.work_done? }
      transition :transferred => :transferred, if: ->(sc) { sc.work_canceled? || sc.work_rejected? }
    end

    event :cancel do
      transition [:new, :open, :transferred] => :canceled, unless: ->(sc) { sc.work_done? }
    end

    event :un_cancel do
      transition :canceled => :transferred, if: ->(sc) { sc.can_uncancel? && sc.subcontractor.present? }
      transition :canceled => :new, if: ->(sc) { sc.can_uncancel? }
    end

    event :close do
      transition :transferred => :closed, if: ->(sc) { sc.subcon_cleared? && sc.payment_cleared? && sc.work_done? }
      transition :open => :closed, if: ->(sc) { sc.payment_paid? && sc.work_done? }
    end

    event :cancel_transfer do
      transition :transferred => :new, unless: ->(sc) { sc.work_done? }
    end
  end

  def process_reopen_event(event)
    # update the customer billing
    CustomerBillingService.new(event).execute
    # update the affiliates billing if one present

    if affiliate.present?
      AffiliateBillingService.new(event).execute
    end

    reopen_payment!

  end

  def can_uncancel?
    !self.work_done?
  end

  def set_ref_id
    self.ref_id = self.id
    update_column :ref_id, self.id
  end

  def my_profit
    adjustment        = entries.select { |e| ['AdjustmentEntry', 'ReceivedAdjEntry', 'MyAdjEntry', 'ReopenedJobAdjustment'].include? e.type }.map { |e| e.amount_cents }.sum
    cancel_adjustment = entries.select { |e| e.type == 'CanceledJobAdjustment' }.map { |e| e.amount_cents }.sum
    customer_cents    = entries.select { |e| e.type == 'ServiceCallCharge' }.map { |b| b.amount_cents }.sum
    adv_payment       = entries.select { |e| e.type == 'AdvancePayment' }.map { |b| b.amount_cents }.sum
    subcon_payments   = entries.select { |e| e.type == 'PaymentToSubcontractor' }.map { |b| b.amount_cents }.sum
    reimb_amount      = entries.select { |e| e.type == 'MaterialReimbursementToCparty' }.map { |b| b.amount_cents }.sum
    my_bom_cents      = -boms.select { |b| b.mine?(really_mine: true) }.map { |b| b.cost_cents * b.quantity }.sum
    payment_reimb     = entries.select { |e| ['ReimbursementForCashPayment', 'ReimbursementForChequePayment', 'ReimbursementForAmexPayment', 'ReimbursementForCreditPayment'].include? e.type }.map { |b| b.amount_cents }.sum


    Money.new(customer_cents +
                  reimb_amount +
                  subcon_payments +
                  my_bom_cents +
                  payment_reimb +
                  cancel_adjustment +
                  adv_payment +
                  adjustment) - tax_amount

  end

  def subcon_collection_fully_deposited?
    collected_entries.map(&:status).select { |status| status == CollectedEntry::STATUS_SUBMITTED }.empty?
  end

  def subcon_collection_disputed?
    deposited_entries.with_status(:disputed).size > 0
  end

  def available_payment_collectors
    res = [self.organization]
    res << self.subcontractor if subcontractor && !subcontractor.member? && subcon_pending?
    res
  end

  def work_start_allowed?
    !self.transferred? && !self.canceled?
  end

end
