class AgrActivatedEvent < AgreementEvent
  def init
    # html_message: '%{updater} has activated the Subcontractor Agreement. You can click on %{link} to review it.'
    # subject: 'A Subcontractor Agreement Was Activated'
    # content: 'You can now transfer and/or receive jobs from %{otherparty}'

    self.name = I18n.t('events.agreement.activated.name')
    self.description = I18n.t('events.agreement.submitted.description', originator: agreement.updater.organization.name, otherparty: other_party) if self.description.nil?
    self.reference_id = 100002
  end

  def notification_recipients
    #  if agreement creator is the organization notify c.party else notify organization
    if agreement.updater.organization == agreement.organization
      User.my_admins(agreement.counterparty.id)
    else
      User.my_admins(agreement.organization.id)
    end
  end

  def notification_class
    AgrNewSubconNotification
  end

  private

  #def other_party
  #  if agreement.updater.organization == agreement.organization
  #    agreement.counterparty
  #  else
  #    agreement.organization
  #  end
  #end


end