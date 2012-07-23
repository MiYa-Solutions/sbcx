class ServiceCall < ActiveRecord::Base
  attr_accessible :customer_id, :notes, :started_on, :completed_on
  belongs_to :customer, :inverse_of => :service_calls
  belongs_to :organization, :inverse_of => :service_calls
end
