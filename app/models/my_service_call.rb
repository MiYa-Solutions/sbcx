class MyServiceCall < ServiceCall

  before_validation do
    self.provider = self.organization.becomes(Provider)
  end


  STATUS_NEW    = 10
  STATUS_CLOSED = 11


  state_machine :status, :initial => :new do
    state :new, value: STATUS_NEW
    state :transferred, value: STATUS_TRANSFERRED
    state :dispatched, value: STATUS_DISPATCHED do
      validates_presence_of :technician
    end
    state :in_progress, value: STATUS_STARTED do
      validates_presence_of :technician
    end
    state :work_done, value: STATUS_WORK_DONE
    state :closed, value: STATUS_CLOSED

    #before_transition :new => :transferred, :do => :transfer_service_call
    #after_transition :new => :local_enabled, :do => :alert_local

    event :dispatch do
      transition [:new] => :dispatched
    end

    event :start do
      transition :dispatched => :in_progress
    end

    event :work_completed do
      transition [:dispatched, :in_progress] => :work_done
    end

    event :customer_paid do
      transition [:work_done, :in_progress] => :closed
    end

    event :transfer do
      transition :new => :transferred
    end

    event :cancel_transfer do
      transition :transferred => :new
    end

    event :settle do
      transition :transferred => :settled
    end

  end

end