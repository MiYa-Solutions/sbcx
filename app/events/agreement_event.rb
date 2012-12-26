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
    if creator.organization == agreement.organization
      other_party = agreement.counterparty
    else
      other_party = agreement.organization
    end
    other_party.subcontrax_member?
  end

end