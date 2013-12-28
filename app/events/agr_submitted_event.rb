class AgrSubmittedEvent < AgreementEvent
  def init
    self.name = I18n.t('events.agreement.submitted.name')
    self.description = I18n.t('events.agreement.submitted.description', originator: agreement.creator.organization.name, counterparty: other_party) if self.description.nil?
    self.reference_id = 200002
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

  def process_event
    update_description_with_reason
    super
  end

  private

  def other_party
    if agreement.creator.organization == agreement.organization
      agreement.counterparty
    else
      agreement.organization
    end
  end

  def update_description_with_reason
    change_reason = agreement.change_reason ? agreement.change_reason : ""
    other_party   = agreement.creator.organization == agreement.organization ? agreement.organization : agreement.counterparty

    self.description = I18n.t('events.agreement.submitted.description', originator: agreement.creator.organization.name, counterparty: other_party.name) +
        ": " + change_reason
    self.save!
  end


end