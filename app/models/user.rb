# == Schema Information
#
# Table name: users
#
#  id                     :integer         not null, primary key
#  email                  :string(255)     default(""), not null
#  encrypted_password     :string(255)     default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer         default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime        not null
#  updated_at             :datetime        not null
#  organization_id        :integer
#  first_name             :string(255)
#  last_name              :string(255)
#  phone                  :string(255)
#  company                :string(255)
#  address1               :string(255)
#  address2               :string(255)
#  country                :string(255)
#  state                  :string(255)
#  city                   :string(255)
#  zip                    :string(255)
#  mobile_phone           :string(255)
#  work_phone             :string(255)
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :organization

  # associations necessary for the Authorization functionality using declarative_authorization
  has_many :assignments
  has_many :roles, through: :assignments
  has_many :events, as: :eventable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password,
                  :password_confirmation,
                  :remember_me,
                  :organization_attributes,
                  :organization,
                  :role_ids,
                  :first_name,
                  :last_name,
                  :phone,
                  :company,
                  :address1,
                  :address2,
                  :country,
                  :state,
                  :city,
                  :zip,
                  :mobile_phone,
                  :work_phone

  accepts_nested_attributes_for :organization

  validates_presence_of :organization, :first_name
  validates_presence_of :roles
  validates_with RoleValidator

  scope :colleagues, ->(org_id) { where("organization_id = ?", org_id) }
  scope :search, ->(query) { where(arel_table[:email].matches("%#{query}%")) }

  def role_symbols
    roles.map do |role|
      role.name.underscore.tr(' ', '_').to_sym
    end
  end
end
