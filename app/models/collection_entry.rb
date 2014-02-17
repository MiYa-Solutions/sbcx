require 'collectible'
class CollectionEntry < AccountingEntry
  include Collectible

  def allowed_status_events
    [:deposit]
  end
end