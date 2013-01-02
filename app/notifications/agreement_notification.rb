class AgreementNotification < Notification
  def agreement
    @agreement ||= notifiable
  end

  def agreement_link
    link_to Agreement.name.underscore.humanize.downcase, url_helpers.agreement_path(agreement)
  end
end