require 'hstore_amount'
require 'collectible'
class ScCollectedByEmployeeEvent < ServiceCallEvent
  include HstoreAmount

  setup_hstore_attr 'collector_id'
  setup_hstore_attr 'collector_type'
  include Collectible

  def init
    self.name         = I18n.t('sc_collected_by_employee_event.name')
    self.description  = I18n.t('sc_collected_by_employee_event.description', employee: collector_name)
    self.reference_id = 100045
  end

  def process_event
    set_customer_account_as_paid collector: collector
    #todo invoke employee billing service
  end

end
