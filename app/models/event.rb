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
