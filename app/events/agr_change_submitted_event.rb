class AgrChangeSubmittedEvent < AgreementEvent

  def init
    self.name         = I18n.t('agr_change_submitted_event.name')
    self.description  = description_with_change_diff.html_safe
    self.reference_id = 200004
  end

  def process_event
    notify User.my_admins(other_party.id), AgrChangeSubmittedNotification, agreement
  end

  private

  def description_with_change_diff
    AgrVersionDiffService.new(last_version, before_last_version).html_description

  end

  def last_version
    agreement.previous_version
  end

  def before_last_version
    agreement.previous_version.try(:previous_version) || last_version
  end

end
