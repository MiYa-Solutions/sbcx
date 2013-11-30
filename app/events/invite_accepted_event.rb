class InviteAcceptedEvent < Event

  def init
    self.name         = I18n.t('invite_accepted_event.name')
    self.description  = I18n.t('invite_accepted_event.description', org: eventable.organization.name, affiliate: eventable.affiliate.name)
    self.reference_id = 4
  end

  def process_event
    eventable.organization.providers << eventable.affiliate
    eventable.organization.subcontractors << eventable.affiliate
    eventable.affiliate.subcontractors << eventable.organization
    eventable.affiliate.providers << eventable.organization
    notify User.my_admins(eventable.organization_id), InviteAcceptedNotification
  end

end
