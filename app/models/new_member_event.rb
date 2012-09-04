class NewMemberEvent < Event
  # this is the event processed by the observer
  def process_event
    Rails.logger.debug "Running NewMemberEvent process"
    org = eventable_type.classify.constantize.find(self.eventable_id)

    AdminMailer.sign_up_alert(org).deliver
  end
end