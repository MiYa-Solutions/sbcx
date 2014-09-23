class NewInviteEvent < Event

  def init
    self.name         = I18n.t('new_invite_event.name')
    self.description  = I18n.t('new_invite_event.description', org: eventable.organization.name, affiliate: eventable.affiliate.name)
    self.reference_id = 2
  end

  def process_event
    if eventable.affiliate.member?
      notify User.my_admins(eventable.affiliate_id), NewInviteNotification
    else
      notify [User.new(email: eventable.affiliate.email, preferences: {'sbcx_reference_notification_email' => 'true'})], SbcxReferenceNotification
    end

  end

end
