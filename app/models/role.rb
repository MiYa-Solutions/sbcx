# == Schema Information
#
# Table name: roles
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Role < ActiveRecord::Base
  has_many :assignments
  has_many :users, :through => :assignments

  ADMIN_ROLE_NAME      = "Admin"
  ORG_ADMIN_ROLE_NAME  = "Org Admin"
  DISPATCHER_ROLE_NAME = "Dispatcher"
  TECHNICIAN_ROLE_NAME = "Technician"

  def to_i
    self.id
  end

  def to_s
    self.name
  end
end
