require 'hstore_setup_methods'
class AgrChangeRejectedEvent < AgreementEvent
  extend HstoreSetupMethods
  setup_hstore_attr 'change_reason'

  def init
    self.name         = I18n.t('agr_change_rejected_event.name')
    self.description  = I18n.t('agr_change_rejected_event.description', other_party: other_party.name)
    self.reference_id = 200005
  end

  def process_event
    notify User.my_admins(other_party), AgrChangeRejectedNotification
  end

end
