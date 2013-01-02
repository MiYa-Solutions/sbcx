class AgrSubmittedEvent < AgreementEvent
  def init
    self.name = I18n.t('events.agreement.submitted.name')
    self.description = I18n.t('events.agreement.submitted.description', originator: agreement.creator.organization.name, otherparty: other_party) if self.description.nil?
    self.reference_id = 100002
  end

  def notification_recipients
    #  if agreement creator is the organization notify c.party else notify organization
    if agreement.creator.organization == agreement.organization
      User.my_admins(agreement.counterparty.id)
    else
      User.my_admins(agreement.organization.id)
    end
  end

  def notification_class
    AgrNewSubconNotification
  end

  private

  def other_party
    if agreement.creator.organization == agreement.organization
      agreement.counterparty
    else
      agreement.organization
    end
  end


end