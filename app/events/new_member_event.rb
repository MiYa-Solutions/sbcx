# == Schema Information
#
# Table name: events
#
#  id             :integer         not null, primary key
#  name           :string(255)
#  type           :string(255)
#  description    :string(255)
#  eventable_type :string(255)
#  eventable_id   :integer
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#  user_id        :integer
#  reference_id   :integer
#

class NewMemberEvent < Event
  # this is the event processed by the observer after the creation
  def process_event
    Rails.logger.debug "Running NewMemberEvent process"
    org = associated_object

    AdminMailer.sign_up_alert(org).deliver
  end

  def init

  end
end
