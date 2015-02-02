class CustomEvent < Event
  validates :reference_id, numericality: { greater_than_or_equal_to: 100, less_than_or_equal_to: 100000 }
  validates_presence_of :name
  attr_accessible :name, :description, :reference_id

  def init
    self.reference_id = 100 unless self.reference_id
    self.description  = '' unless self.description
  end

  def process_event
    # the event does nothing, just is being registered
  end
end