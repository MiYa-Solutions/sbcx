class AgrChangeSubmittedEvent < AgreementEvent

  def init
    self.name         = I18n.t('agr_change_submitted_event.name')
    self.description  = description_with_change_diff
    self.reference_id = 200004
  end

  def process_event
    notify User.my_admins(other_party.id), AgrChangeSubmittedNotification, agreement
  end

  def html_description

  end

  private

  def description_with_change_diff
    AgrVersionDiffService.new(agreement.previous_version,
                              agreement.previous_version.previous_version).html_description

  end

end
