require 'hstore_amount'
require 'collectible'
class CollectionEvent < ServiceCallEvent
  include HstoreAmount

  setup_hstore_attr 'collector_id'
  setup_hstore_attr 'collector_type'
  setup_hstore_attr 'notes'
  include Collectible

end