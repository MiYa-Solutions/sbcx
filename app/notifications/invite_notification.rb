class InviteNotification < Notification
  alias_method :invite, :notifiable

  def invite_link
    link_to Invite.model_name.human.downcase, url_helpers.invite_path(invite)
  end


end