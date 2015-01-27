# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
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
#  time_zone              :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#

class User < ActiveRecord::Base
  acts_as_token_authenticatable
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable

  # *notification preferences*
  serialize :preferences, ActiveRecord::Coders::Hstore

  before_create :setup_default_notifications

  # end of notification preferences


  SYSTEM_USER_EMAIL = ENV["SYSTEM_USER_EMAIL"] ? ENV["SYSTEM_USER_EMAIL"] : "system@subcontrax.com"
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

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
  scope :admins, -> { includes(:roles).where("roles.name = ?", Role::ORG_ADMIN_ROLE_NAME) }
  scope :dispatchers, -> { includes(:roles).where("roles.name = ?", Role::DISPATCHER_ROLE_NAME) }
  scope :my_technicians, ->(org_id, columns) { technicians.where("organization_id = ?", org_id).select(columns) }
  scope :my_dispatchers, ->(org_id) { dispatchers.where("organization_id = ?", org_id) }

  def role_symbols
    roles.map do |role|
      role.name.underscore.tr(' ', '_').to_sym
    end
  end

  def settings
    @settings ||= Settings.new(self)
  end

  private

  def setup_default_notifications
    self.preferences = { 'sc_received_notification'                   => 'true',
                         'sc_received_notification_email'             => 'true',
                         'sc_accepted_notification'                   => 'true',
                         'sc_cancel_notification'                     => 'true',
                         'sc_cancel_notification_email'               => 'true',
                         'sc_rejected_notification'                   => 'true',
                         'sc_rejected_notification_email'             => 'true',
                         'sc_canceled_notification'                   => 'true',
                         'sc_canceled_notification_email'             => 'true',
                         'sc_completed_notification'                  => 'true',
                         'sc_completed_notification_email'            => 'true',
                         'sc_complete_notification'                   => 'true',
                         'sc_complete_notification_email'             => 'true',
                         'sc_collected_notification'                  => 'true',
                         'sc_deposit_confirmed_notification'          => 'true',
                         'sc_dispatch_notification'                   => 'true',
                         'sc_dispatched_notification'                 => 'true',
                         'sc_dispatched_notification_email'           => 'true',
                         'sc_paid_notification'                       => 'true',
                         'sc_props_updated_notification'              => 'true',
                         'sc_provider_canceled_notification'          => 'true',
                         'sc_provider_canceled_notification_email'    => 'true',
                         'sc_provider_collected_notification'         => 'true',
                         'sc_provider_confirmed_settled_notification' => 'true',
                         'sc_provider_settled_notification'           => 'true',
                         'sc_provider_settled_notification'           => 'true',
                         'sc_provider_settled_notification_email'     => 'true',
                         'sc_start_notification'                      => 'true',
                         'sc_started_notification'                    => 'true',
                         'sc_subcon_cleared_notification'             => 'true',
                         'sc_subcon_confirmed_settled_notification'   => 'true',
                         'sc_subcon_deposited_notification'           => 'true',
                         'sc_subcon_settled_notification'             => 'true',
                         #invite
                         'invite_accepted_notification'               => 'true',
                         'invite_accepted_notification_email'         => 'true',
                         'invite_declined_notification'               => 'true',
                         'invite_declined_notification_email'         => 'true',
                         'new_invite_notification'                    => 'true',
                         'new_invite_notification_email'              => 'true',
                         #agreement notifications
                         'agr_new_subcon_notification'                => 'true',
                         'agr_new_subcon_notification_email'          => 'true',
                         'agr_change_rejected_notification'           => 'true',
                         'agr_change_rejected_notification_email'     => 'true',
                         'agr_change_submitted_notification'          => 'true',
                         'agr_change_submitted_notification_email'    => 'true',
                         'agr_subcon_accepted_notification'           => 'true',
                         'agr_subcon_accepted_notification_email'     => 'true',
                         #adj entry notifications
                         'acc_adj_accepted_notification'              => 'true',
                         'acc_adj_accepted_notification_email'        => 'true',
                         'acc_adj_rejected_notification'              => 'true',
                         'acc_adj_rejected_notification_email'        => 'true',
                         'acc_adj_canceled_notification'              => 'true',
                         'acc_adj_canceled_notification_email'        => 'true',
                         'account_adjusted_notification'              => 'true',
                         'account_adjusted_notification_email'        => 'true',
                         #for 3rd party collection deposit
                         'entry_disputed_notification'                => 'true',
                         'entry_disputed_notification_email'          => 'true'
    }
  end
end
