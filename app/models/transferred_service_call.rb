# == Schema Information
#
# Table name: tickets
#
#  id                   :integer          not null, primary key
#  customer_id          :integer
#  notes                :text
#  started_on           :datetime
#  organization_id      :integer
#  completed_on         :datetime
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  status               :integer
#  subcontractor_id     :integer
#  technician_id        :integer
#  provider_id          :integer
#  subcontractor_status :integer
#  type                 :string(255)
#  ref_id               :integer
#  creator_id           :integer
#  updater_id           :integer
#  settled_on           :datetime
#  billing_status       :integer
#  settlement_date      :datetime
#  name                 :string(255)
#  scheduled_for        :datetime
#  transferable         :boolean          default(FALSE)
#  allow_collection     :boolean          default(TRUE)
#  collector_id         :integer
#  collector_type       :string(255)
#  provider_status      :integer
#  work_status          :integer
#  re_transfer          :boolean
#  payment_type         :string(255)
#  subcon_payment       :string(255)
#  provider_payment     :string(255)
#

class TransferredServiceCall < ServiceCall
  validates_presence_of :provider
  validate :provider_is_not_a_member
  before_validation do
    self.subcontractor ||= self.organization.try(:becomes, Subcontractor)
  end

  STATUS_NEW         = 1200
  STATUS_ACCEPTED    = 1201
  STATUS_REJECTED    = 1202
  STATUS_TRANSFERRED = 1203
  STATUS_CLOSED      = 1204
  STATUS_CANCELED    = 1205

  state_machine :status, :initial => :new do
    state :new, value: STATUS_NEW
    state :accepted, value: STATUS_ACCEPTED
    state :rejected, value: STATUS_REJECTED
    state :transferred, value: STATUS_TRANSFERRED do
      validate { |sc| sc.validate_subcon }
    end
    state :closed, value: STATUS_CLOSED
    state :canceled, value: STATUS_CANCELED

    after_failure do |service_call, transition|
      Rails.logger.debug { "Transferred Service Call status state machine failure. Service Call errors : \n" + service_call.errors.messages.inspect + "\n The transition: " +transition.inspect }
    end

    event :accept do
      transition :new => :accepted
    end

    event :un_accept do
      transition :accepted => :rejected, unless: ->(sc) { sc.work_done? }
    end

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
      transition [:accepted, :new] => :canceled
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
      sc.status = SUBCON_STATUS_CLEARED if sc.provider_payment == 'cash'
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

  BILLING_STATUS_NA                     = 4200
  BILLING_STATUS_PENDING                = 4201
  BILLING_STATUS_INVOICED               = 4202
  BILLING_STATUS_COLLECTED_BY_EMPLOYEE  = 4203
  BILLING_STATUS_COLLECTED              = 4204
  BILLING_STATUS_DEPOSITED_TO_PROV      = 4205
  BILLING_STATUS_DEPOSITED              = 4206
  BILLING_STATUS_INVOICED_BY_SUBCON     = 4207
  BILLING_STATUS_COLLECTED_BY_SUBCON    = 4208
  BILLING_STATUS_SUBCON_CLAIM_DEPOSITED = 4209
  BILLING_STATUS_INVOICED_BY_PROV       = 4210
  # if collection is not allowed for this service call, then the initial status is set to na - not applicable
  state_machine :billing_status, initial: lambda { |sc| sc.allow_collection? ? :pending : :na }, namespace: 'payment' do
    state :na, value: BILLING_STATUS_NA
    state :pending, value: BILLING_STATUS_PENDING
    state :invoiced, value: BILLING_STATUS_INVOICED
    state :collected_by_employee, value: BILLING_STATUS_COLLECTED_BY_EMPLOYEE do
      validate { |sc| sc.validate_collector }
    end
    state :collected, value: BILLING_STATUS_COLLECTED do
      validate do |sc|
        sc.validate_collector
        sc.validate_payment
      end
    end
    state :deposited_to_prov, value: BILLING_STATUS_DEPOSITED_TO_PROV
    state :deposited, value: BILLING_STATUS_DEPOSITED do
      validate { |sc| sc.validate_collector }
    end
    state :invoiced_by_subcon, value: BILLING_STATUS_INVOICED_BY_SUBCON
    state :collected_by_subcon, value: BILLING_STATUS_COLLECTED_BY_SUBCON do
      validate do |sc|
        sc.validate_collector
        sc.validate_payment
      end
    end
    state :subcon_claim_deposited, value: BILLING_STATUS_SUBCON_CLAIM_DEPOSITED
    state :invoiced_by_prov, value: BILLING_STATUS_INVOICED_BY_PROV

    after_failure do |service_call, transition|
      Rails.logger.debug { "Transferred Service Call billing status state machine failure. Service Call errors : \n" + service_call.errors.messages.inspect + "\n The transition: " +transition.inspect }
    end

    event :invoice do
      transition :pending => :invoiced, if: lambda { |sc| sc.work_done? }
    end

    event :subcon_invoiced do
      transition :pending => :invoiced_by_subcon, if: lambda { |sc| sc.work_done? && sc.subcontractor }
    end

    event :provider_invoiced do
      transition :pending => :invoiced_by_prov, if: lambda { |sc| sc.work_done? }
    end

    event :provider_collected do
      transition [:invoiced_by_prov, :invoiced] => :deposited
    end

    event :collect do
      transition [:invoiced, :invoiced_by_subcon] => :collected_by_employee, if: lambda { |sc| sc.organization.multi_user? }
      transition [:invoiced, :invoiced_by_subcon] => :collected, if: lambda { |sc| !sc.organization.multi_user? }
    end

    event :employee_deposit do
      transition :collected_by_employee => :collected
    end

    event :subcon_collected do
      transition :invoiced_by_subcon => :collected_by_subcon
    end

    event :subcon_deposited do
      transition :collected_by_subcon => :subcon_claim_deposited
    end

    event :confirm_deposit do
      transition :subcon_claim_deposited => :collected
    end

    event :deposit_to_prov do
      transition :collected => :deposited_to_prov
    end

    event :prov_confirmed_deposit do
      transition :deposited_to_prov => :deposited
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

  def can_uncancel?
    !self.work_done? && !self.provider.subcontrax_member?  &&
        ((self.subcontractor.present? && !self.subcontractor.subcontrax_member?) || self.subcontractor.nil?)
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




end
