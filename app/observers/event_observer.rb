class EventObserver < ActiveRecord::Observer
  def after_create(model)
    Rails.logger.debug "Running Event Observer after_create"
    Rails.logger.debug model.inspect
    model.process_event
  end
end