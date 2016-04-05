class EventObserver < ActiveRecord::Observer
  def after_create(model)
    Rails.logger.debug {"Running Event Observer after_create for #{model.name}"}
    Rails.logger.debug model.inspect
    model.user = model.updater

    model.process_event
  end
end