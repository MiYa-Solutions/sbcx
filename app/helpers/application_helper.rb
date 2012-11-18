module ApplicationHelper

  def notifications
    current_user.notifications
  end
end
