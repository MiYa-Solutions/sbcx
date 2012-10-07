class TransferredServiceCall < ServiceCall
  validates_presence_of :provider

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

    event :settle do
      transition :work_done => :settled
    end

    event :work_completed do
      transition [:in_progress, :dispatched] => :work_done
    end

    event :customer_paid do
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

    event :subcon_transfer do
      transition [:na] => :transferred
    end

    event :subcon_accept do
      transition :transferred => :accepted
    end
    event :subcon_reject do
      transition :transferred => :rejected
    end
    event :subcon_start do
      transition [:accepted] => :in_progress
    end
    event :subcon_complete do
      transition [:in_progress] => :work_done
    end
    event :subcon_settle do
      transition [:work_done] => :settled
    end

  end
end