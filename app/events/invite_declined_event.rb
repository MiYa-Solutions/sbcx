class InviteDeclinedEvent < Event

  def init
    self.name         = I18n.t('invite_declined_event.name')
    self.description  = I18n.t('invite_declined_event.description', org: eventable.organization.name, affiliate: eventable.affiliate.name)
    self.reference_id = 3
  end

  def process_event
    notify User.my_admins(eventable.organization_id), InviteDeclinedNotification
  end

end
