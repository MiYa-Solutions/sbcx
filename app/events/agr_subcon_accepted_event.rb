class AgrSubconAcceptedEvent < AgreementEvent

  def init
    self.name         = I18n.t('agr_subcon_accepted_event.name')
    self.description  = I18n.t('agr_subcon_accepted_event.description', other_party: other_party.name)
    self.reference_id = 200003
  end

  def notification_recipients
    User.my_admins(other_party.id)
  end

  def notification_class

    AgrSubconAcceptedNotification

  end


end
