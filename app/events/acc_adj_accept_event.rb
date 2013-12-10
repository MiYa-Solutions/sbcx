class AccAdjAcceptEvent < Event

  def init
    self.name         = 'CHANGE ME'
    self.description  = 'CHANGE ME'
    self.reference_id = 'UPDATE IN EVENT EXCEL AND CHANGE ME'
  end

  def process_event
    raise "Event base class was invoked instead of one of the sub-classes"
  end

end
