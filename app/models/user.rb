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
#  preferences            :hstore
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable

  # *notification preferences*
  serialize :preferences, ActiveRecord::Coders::Hstore

  %w[alert1 alert2].each do |key|
    scope "has_#{key}", lambda { |org_id, value| colleagues(org_id).where("preferences @> (? => ?)", key, value) }

    define_method(key) do
      preferences && preferences[key]
    end

    define_method("#{key}=") do |value|
      self.preferences = (preferences || { }).merge(key => value)
    end
  end

  # end of notification preferences


  SYSTEM_USER_EMAIL = ENV["SYSTEM_USER_EMAIL"] ? ENV["SYSTEM_USER_EMAIL"] : "system@subcontrax.com"
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :organization
  model_stamper

  # associations necessary for the Authorization functionality using declarative_authorization
  has_many :assignments
  has_many :roles, through: :assignments
  has_many :events, as: :eventable
  has_many :notifications
  has_many :boms, as: :buyer

  accepts_nested_attributes_for :organization

  # todo make role lookup based on ids and not names
  scope :my_admins, ->(org_id) { includes(:roles).where("roles.name = ? AND organization_id = ?", "#{Role::ORG_ADMIN_ROLE_NAME}", org_id) }

  attr_writer :name

  def name
    @name ||= "#{self.first_name} #{last_name}"
  end

  validates_presence_of :organization, :first_name
  validates_presence_of :roles
  validates_with RoleValidator


  scope :colleagues, ->(org_id) { where("organization_id = ?", org_id) }
  scope :search, ->(query) { where(arel_table[:email].matches("%#{query}%")) }
  scope :technicians, -> { includes(:roles).where("roles.name = ?", Role::TECHNICIAN_ROLE_NAME) }
  scope :dispatchers, -> { includes(:roles).where("roles.name = ?", Role::DISPATCHER_ROLE_NAME) }
  scope :my_technicians, ->(org_id, columns) { technicians.where("organization_id = ?", org_id).select(columns) }
  scope :my_dispatchers, ->(org_id) { dispatchers.where("organization_id = ?", org_id) }

  def role_symbols
    roles.map do |role|
      role.name.underscore.tr(' ', '_').to_sym
    end
  end
end
