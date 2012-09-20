class NewMemberEvent < Event
  # this is the event processed by the observer after the creation
  def process_event
    Rails.logger.debug "Running NewMemberEvent process"
    org = associated_object

    AdminMailer.sign_up_alert(org).deliver
  end
end