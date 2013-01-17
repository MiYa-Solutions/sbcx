##
# Events are the core unites that implement behavior. Events are created in various scenarios but the most common one is
# in response to a status change in a state machine. Events are polymorphic and so can be associated with any model
# that has_many events as eventable.
#
# [How events work?] events are designed to work asynchronously using EventObserver which invokes the init and process_event methods,
#                    which should be implemented by the subclasses, as Event is a abstract class and so not
#                    expected to be instantiated.
# [Notifications] Each event is associated with a notification which is specified in the
#
# == Creating a new event
# In order to create a new event you should:
# 1. create a subclass of Event and place it in the ./app/events folder
# 2. implement the process_event method
# 3. implement the init method to initialize the name subject and reference id attributes
# 4. invoke the event creation where appropriate, for example upon the state machine event (which is different for this event)
#    triggering:
#
#    [state_machine example] assuming you have a model with a state_machine that has an "action1" event defined:
#
#                               class MyModel < ActiveRecord::Base
#                                 state_machine :status do
#                                    ...
#                                     event :action1 do
#                                        ...
#                                     end
#`
#                                 end
#                               end
#
#                            Assuming you are using an observer (as oppose to callback methods), the following method is expected
#
#                               class ServiceCallObserver < ActiveRecord::Observer
#
#                                    def after_action1(obj, transition)
#                                      obj.events << MyEvent.new
#                                    end
#                               end
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
#  creator_id     :integer
#  updater_id     :integer
#

class Event < ActiveRecord::Base
  attr_accessible :name, :description
  belongs_to :eventable, polymorphic: true
  belongs_to :user
  stampable

  before_validation :init

  def process_event
    raise "Event base class was invoked instead of one of the sub-classes"
  end

  def associated_object
    eventable_type.classify.constantize.find(self.eventable_id)
  end

  def init
    raise "Event base class was invoked instead of one of the sub-classes. Did you forget to implement init for: #{self.class.name} ?"
  end

  def notify(users, notification_class)

    users.each do |user|
      notification = notification_class.new(user: user)
      unless user == eventable.updater
        eventable.notifications << notification
        notification.deliver
      end

    end

  end


end
