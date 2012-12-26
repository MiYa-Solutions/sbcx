class AgrNewSubconEvent < AgreementEvent
  def init
    self.name         = I18n.t('events.agreement.new_subcon_agreement.name')
    self.description  = I18n.t('events.agreement.new_subcon_agreement.description',)
    self.reference_id = 100001
  end

  def notification_recipients
    #  if agreement creator is the organization notify c.party else notify organization
    if creator.organization == agreement.organization
      User.my_admins(agreement.counterparty.id)
    else
      User.my_admins(agreement.organization.id)
    end
  end

  def notification_class
    AgrNewSubconNotification
  end


end