# == Schema Information
#
# Table name: organizations
#
#  id                :integer         not null, primary key
#  name              :string(255)
#  phone             :string(255)
#  website           :string(255)
#  company           :string(255)
#  address1          :string(255)
#  address2          :string(255)
#  city              :string(255)
#  state             :string(255)
#  zip               :string(255)
#  country           :string(255)
#  mobile            :string(255)
#  work_phone        :string(255)
#  email             :string(255)
#  subcontrax_member :boolean
#  status            :integer
#  created_at        :datetime        not null
#  updated_at        :datetime        not null
#

class Organization < ActiveRecord::Base


  attr_accessible :address1,
                  :address2,
                  :city,
                  :company,
                  :country,
                  :email,
                  :mobile,
                  :name,
                  :phone,
                  :state,
                  :status,
                  :subcontrax_member,
                  :website,
                  :work_phone,
                  :zip,
  :organization_role_ids


  has_many :users
  has_many :org_to_roles
  has_many :organization_roles, :through => :org_to_roles

  validates :name, { presence: true, length: { maximum: 255 } }



                                                                                                                                                      end
