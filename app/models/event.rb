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
#

class Event < ActiveRecord::Base
  attr_accessible :name, :description
  belongs_to :eventable, polymorphic: true
  belongs_to :user

  def process_event
    raise "Event base class was invoked instead of one of the sub-classes"
  end

  def associated_object
    eventable_type.classify.constantize.find(self.eventable_id)
  end

end
