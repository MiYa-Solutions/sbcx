# == Schema Information
#
# Table name: tickets
#
#  id                    :integer          not null, primary key
#  customer_id           :integer
#  notes                 :text
#  started_on            :datetime
#  organization_id       :integer
#  completed_on          :datetime
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  status                :integer
#  subcontractor_id      :integer
#  technician_id         :integer
#  provider_id           :integer
#  subcontractor_status  :integer
#  type                  :string(255)
#  ref_id                :integer
#  creator_id            :integer
#  updater_id            :integer
#  settled_on            :datetime
#  billing_status        :integer
#  settlement_date       :datetime
#  name                  :string(255)
#  scheduled_for         :datetime
#  transferable          :boolean          default(FALSE)
#  allow_collection      :boolean          default(TRUE)
#  collector_id          :integer
#  collector_type        :string(255)
#  provider_status       :integer
#  work_status           :integer
#  re_transfer           :boolean
#  payment_type          :string(255)
#  subcon_payment        :string(255)
#  provider_payment      :string(255)
#  company               :string(255)
#  address1              :string(255)
#  address2              :string(255)
#  city                  :string(255)
#  state                 :string(255)
#  zip                   :string(255)
#  country               :string(255)
#  phone                 :string(255)
#  mobile_phone          :string(255)
#  work_phone            :string(255)
#  email                 :string(255)
#  subcon_agreement_id   :integer
#  provider_agreement_id :integer
#  tax                   :float            default(0.0)
#

class MyServiceCall < ServiceCall

  before_validation do
    self.provider = self.organization.becomes(Provider)
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
    end

    event :cancel do
      transition [:new, :open, :transferred] => :canceled
    end

    event :un_cancel do
      transition :canceled => :transferred, if: ->(sc) { sc.can_uncancel? && sc.subcontractor.present? }
      transition :canceled => :new, if: ->(sc) { sc.can_uncancel? }
    end

    event :close do
      transition :transferred => :closed, if: ->(sc) { sc.subcon_cleared? && sc.payment_cleared? }
      transition :open => :closed, if: ->(sc) { sc.payment_cleared? }
    end

    event :cancel_transfer do
      transition :transferred => :new, if: ->(sc) { !sc.work_done? }
    end
  end

  BILLING_STATUS_PENDING                = 4100
  BILLING_STATUS_INVOICED               = 4101
  BILLING_STATUS_COLLECTED_BY_EMPLOYEE  = 4102
  BILLING_STATUS_OVERDUE                = 4103
  BILLING_STATUS_PAID                   = 4104
  BILLING_STATUS_INVOICED_BY_SUBCON     = 4105
  BILLING_STATUS_COLLECTED_BY_SUBCON    = 4106
  BILLING_STATUS_SUBCON_CLAIM_DEPOSITED = 4107
  BILLING_STATUS_CLEARED                = 4108


  # if collection is not allowed for this service call, then the initial status is set to na - not applicable
  state_machine :billing_status, initial: :pending, namespace: 'payment' do
    state :pending, value: BILLING_STATUS_PENDING
    state :invoiced, value: BILLING_STATUS_INVOICED
    state :collected_by_employee, value: BILLING_STATUS_COLLECTED_BY_EMPLOYEE do
      validate { |sc| sc.validate_collector }
    end
    state :overdue, value: BILLING_STATUS_OVERDUE
    state :paid, value: BILLING_STATUS_PAID
    state :invoiced_by_subcon, value: BILLING_STATUS_INVOICED_BY_SUBCON
    state :collected_by_subcon, value: BILLING_STATUS_COLLECTED_BY_SUBCON do
      validate { |sc| sc.validate_collector }
    end
    state :subcon_claim_deposited, value: BILLING_STATUS_SUBCON_CLAIM_DEPOSITED
    state :cleared, value: BILLING_STATUS_CLEARED

    after_failure do |service_call, transition|
      Rails.logger.debug { "My Service Call billing status state machine failure. Service Call errors : \n" + service_call.errors.messages.inspect + "\n The transition: " +transition.inspect }
    end

    # for cash payment, paid means cleared
    after_transition any => :paid do |sc, transition|
      sc.billing_status = BILLING_STATUS_CLEARED if sc.payment_type == 'cash'
      sc.save
    end

    event :clear do
      transition :paid => :cleared, if: ->(sc) { !sc.canceled? && sc.payment_type != 'cash' }
    end

    event :invoice do
      transition :pending => :invoiced, if: ->(sc) { sc.work_done? }
    end

    event :subcon_invoiced do
      transition :pending => :invoiced_by_subcon, if: ->(sc) { !sc.canceled? && sc.transferred? && sc.work_done? && sc.allow_collection? }
    end

    event :overdue do
      transition [:invoiced, :invoiced_by_subcon] => :overdue, if: ->(sc) { !sc.canceled? }
    end

    event :collect do
      transition [:invoiced, :overdue, :invoiced_by_subcon] => :collected_by_employee, if: ->(sc) { !sc.canceled? && sc.organization.multi_user? }
    end

    event :deposited do
      transition :collected_by_employee => :paid, if: ->(sc) { !sc.canceled? }
    end

    event :paid do
      transition [:invoiced, :invoiced_by_subcon, :overdue] => :paid, if: ->(sc) { !sc.canceled? && !sc.organization.multi_user? }
    end

    event :subcon_collected do
      transition :invoiced_by_subcon => :collected_by_subcon, if: ->(sc) { !sc.canceled? }
    end

    event :subcon_deposited do
      transition :collected_by_subcon => :subcon_claim_deposited, if: ->(sc) { !sc.canceled? }
    end

    event :confirm_deposit do
      transition :subcon_claim_deposited => :paid, if: ->(sc) { !sc.canceled? }
    end
  end

  def can_uncancel?
    #!self.work_done? &&
    #    ((self.transferred? && !self.subcontractor.subcontrax_member?) || !self.transferred?)

    !self.work_done?


  end

  def set_ref_id
    self.ref_id = self.id
    update_column :ref_id, self.id
  end

end
