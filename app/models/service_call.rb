# == Schema Information
#
# Table name: service_calls
#
#  id              :integer         not null, primary key
#  customer_id     :integer
#  notes           :text
#  started_on      :datetime
#  organization_id :integer
#  completed_on    :datetime
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#

class ServiceCall < ActiveRecord::Base
  attr_accessible :customer_id, :notes, :started_on, :completed_on
  belongs_to :customer, :inverse_of => :service_calls
  belongs_to :organization, :inverse_of => :service_calls
end
