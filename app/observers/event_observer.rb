class EventObserver < ActiveRecord::Observer
  def after_create(model)
    Rails.logger.debug "Running Event Observer after_create"
    Rails.logger.debug model.inspect
    model.user = model.updater

    QC.enqueue "Event.background_process", model.id
  end
end