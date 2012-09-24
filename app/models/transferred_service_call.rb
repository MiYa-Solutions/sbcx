class TransferredServiceCall < ServiceCall
  validates_presence_of :provider

  before_validation do
    self.subcontractor = self.organization.becomes(Subcontractor)
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
      transition :in_progress => :work_done
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
end