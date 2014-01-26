module Collectible
  def self.included(base)
    base.belongs_to :collector, polymorphic: true
    base.validates_presence_of :collector
  end

  def collector_name
    collector ? collector.name : ''
  end

end