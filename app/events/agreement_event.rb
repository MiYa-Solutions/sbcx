class AgreementEvent < Event

  def process_event

    Rails.logger.debug { "Running #{self.class.name} process_event method" }

    if notify_other_party?
      notify notification_recipients, notification_class unless notification_recipients.nil?
    end


  end

  def agreement
    @agreement ||= self.eventable
  end

  def notify_other_party?
    other_party.subcontrax_member?
  end

  # returns the agreement party based on the creator of the event
  def other_party
    if self.creator.organization == agreement.organization
      agreement.counterparty
    else
      agreement.organization
    end
  end

end