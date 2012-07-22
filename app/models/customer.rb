# == Schema Information
#
# Table name: customers
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  organization_id :integer
#  company         :string(255)
#  address1        :string(255)
#  address2        :string(255)
#  city            :string(255)
#  state           :string(255)
#  zip             :string(255)
#  country         :string(255)
#  phone           :string(255)
#  mobile_phone    :string(255)
#  work_phone      :string(255)
#  email           :string(255)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#

class Customer < ActiveRecord::Base
  # todo check if organization_id can be removed
  # todo ensure customers are retrieved only with org id to prevent from unauthorized orgs to see customers
  attr_accessible :address1, :address2, :city, :company, :country, :email, :mobile_phone, :name, :organization_id, :phone, :state, :work_phone, :zip
  belongs_to :organization, inverse_of: :customers
  validates_presence_of :organization
  has_many :service_calls, :inverse_of => :customer

end
