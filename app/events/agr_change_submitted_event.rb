require 'hstore_setup_methods'
class AgrChangeSubmittedEvent < AgreementEvent

  extend HstoreSetupMethods

  setup_hstore_attr 'change_reason'


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
    "#{change_reason} \n #{AgrVersionDiffService.new(agreement.last_version, agreement.before_last_version).html_description}"

  end


end
