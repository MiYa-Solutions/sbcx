=begin
AgreementEvent is an abstract class which extends the Event class with additional functionality specific to events
related to agreements
=end

class AgreementEvent < Event

  ##
  # this is the standard event method which gets invoked by the EventObserver after the creation
  def process_event

    Rails.logger.debug { "Running #{self.class.name} process_event method" }

    if notify_other_party?
      notify notification_recipients, notification_class unless notification_recipients.nil?
    end
  end

  ##
  # return the agreement this event is associated with
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