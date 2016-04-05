class AgreementNotification < Notification
  def agreement
    @agreement ||= notifiable
  end

  def agreement_link
    link_to Agreement.name.underscore.humanize.downcase, url_helpers.agreement_path(agreement)
  end

  def other_party
    if agreement.organization == user.organization
      agreement.counterparty
    else
      agreement.organization
    end
  end
end