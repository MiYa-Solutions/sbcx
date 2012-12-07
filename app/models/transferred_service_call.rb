# == Schema Information
#
# Table name: service_calls
#
#  id                   :integer         not null, primary key
#  customer_id          :integer
#  notes                :text
#  started_on           :datetime
#  organization_id      :integer
#  completed_on         :datetime
#  created_at           :datetime        not null
#  updated_at           :datetime        not null
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
#  total_price          :decimal(, )
#

class TransferredServiceCall < ServiceCall
  validates_presence_of :provider
  validate :provider_is_not_a_member
  before_validation do
    self.subcontractor ||= self.organization.try(:becomes, Subcontractor)
  end


  STATUS_RECEIVED_NEW = 20
  STATUS_ACCEPTED     = 21
  STATUS_REJECTED     = 22

  state_machine :status, :initial => :received_new do
    state :received_new, value: STATUS_RECEIVED_NEW
    state :accepted, value: STATUS_ACCEPTED
    state :rejected, value: STATUS_REJECTED
    state :dispatched, value: STATUS_DISPATCHED do
      validates_presence_of :technician
    end
    state :transferred, value: STATUS_TRANSFERRED
    state :in_progress, value: STATUS_STARTED do
      validates_presence_of :technician
    end
    state :work_done, value: STATUS_WORK_DONE
    state :settled, value: STATUS_SETTLED
    state :canceled, value: STATUS_CANCELED

    event :cancel do
      transition [:received_new, :accepted, :in_progress] => :canceled
    end

    event :settle do
      transition :work_done => :settled
    end

    event :work_completed do
      transition [:in_progress, :dispatched] => :work_done
    end

    event :paid do
      transition [:in_progress, :work_done] => :work_done
    end

    event :start do
      transition [:accepted, :received_new, :dispatched] => :in_progress
    end

    event :reject do
      transition :received_new => :rejected
    end

    #before_transition :new => :transferred, :do => :transfer_service_call
    #after_transition :new => :local_enabled, :do => :alert_local

    event :accept do
      transition :received_new => :accepted
    end

    event :dispatch do
      transition [:accepted, :received_new] => :dispatched
    end

    event :transfer do
      transition :received_new => :transferred
    end

  end


  state_machine :subcontractor_status, :initial => :na, namespace: 'subcon' do
    state :na, value: SUBCON_STATUS_NA
    state :pending, value: SUBCON_STATUS_PENDING
    state :accepted, value: SUBCON_STATUS_ACCEPTED
    state :rejected, value: SUBCON_STATUS_REJECTED
    state :transferred, value: SUBCON_STATUS_TRANSFERRED
    state :in_progress, value: SUBCON_STATUS_IN_PROGRESS
    state :work_done, value: SUBCON_STATUS_WORK_DONE
    state :settled, value: SUBCON_STATUS_SETTLED
    state :paid, value: SUBCON_STATUS_PAID

    event :subcon_transfer do
      transition [:na] => :pending
    end

    event :accept do
      transition :pending => :accepted
    end
    event :reject do
      transition :pending => :rejected
    end
    event :start do
      transition [:pending, :accepted] => :in_progress
    end
    event :subcon_complete do
      transition [:pending, :accepted, :in_progress] => :work_done
    end
    event :subcon_settle do
      transition [:work_done] => :settled
    end

    event :paid do
      transition [:accepted, :in_progress] => :paid
    end
  end
  private
  def provider_is_not_a_member
    if provider
      if provider.subcontrax_member && ServiceCall.find_by_ref_id_and_organization_id(ref_id, provider_id).nil?
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
