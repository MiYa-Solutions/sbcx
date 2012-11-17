# == Schema Information
#
# Table name: service_calls
#
#  id                   :integer         not null, primary key
#  customer_id          :integer
#  notes                :text
#  started_on           :datetime
#  organization_id      :integer
#  completed_on         :datetime
#  created_at           :datetime        not null
#  updated_at           :datetime        not null
#  status               :integer
#  subcontractor_id     :integer
#  technician_id        :integer
#  provider_id          :integer
#  subcontractor_status :integer
#  type                 :string(255)
#  ref_id               :integer
#  creator_id           :integer
#  updater_id           :integer
#  settled_on           :datetime
#  billing_status       :integer
#  total_price          :decimal(, )
#

class ServiceCall < ActiveRecord::Base
  #attr_accessible :customer_id, :notes, :started_on, :completed_on, :completed_on_text, :started_on_text, :new_customer, :status_event, :subcontractor_id, :provider_id, :technician_id, :total_price
  belongs_to :customer, :inverse_of => :service_calls
  belongs_to :organization, :inverse_of => :service_calls
  belongs_to :subcontractor
  belongs_to :provider
  belongs_to :technician, class_name: User
  has_many :events, as: :eventable

  stampable

  # virtual attributes
  attr_writer :started_on_text, :completed_on_text, :company, :address1, :address2,
              :city, :state, :zip, :country, :phone, :mobile_phone, :work_phone, :email
  attr_accessor :new_customer

  # transform the dates before saving
  before_save :save_started_on_text
  before_save :save_completed_on_text
  # create a new customer in case one was asked for
  before_validation :create_customer

  validate :check_completed_on_text, :check_started_on_text, :customer_belongs_to_provider
  validates_presence_of :organization, :provider
  validates_presence_of :customer, if: "new_customer.nil? ||  new_customer.empty?"


  accepts_nested_attributes_for :customer

  def company
    @company ||= customer.try(:company)
  end

  def address1
    @address1 ||= customer.try(:address1)
  end

  def address2
    @address2 ||= customer.try(:address2)
  end

  def city
    @city ||= customer.try(:city)
  end

  def state
    @state ||= customer.try(:city)
  end

  def zip
    @zip ||= customer.try(:zip)
  end

  def country
    @country ||= customer.try(:country)
  end

  def phone
    @phone ||= customer.try(:phone)
  end

  def mobile_phone
    @mobile_phone ||= customer.try(:mobile_phone)

  end

  def work_phone
    @work_phone ||= customer.try(:work_phone)
  end

  def email
    @email ||= customer.try(:email)
  end

  # if im not the subcontractor of this service call then I'm the provider
  def my_role
    if subcontractor_id.nil?
      if provider_id.nil?
        @my_role = :prov
      else
        @my_role = :subcon
      end
    else
      @my_role ||= self.organization_id == self.subcontractor_id ? :subcon : :prov

    end
  end


# State machine  for ServiceCall status
# first we will define the service call state values

# common statuses for all service call types
# specific statuses will be setup in each sub-class by prefixing with an integer to avoid conflicts
# i.e. STATUS_SUBCLASS_STATUS = 41 (4 being the subclass status identifier)
  STATUS_NA          = 0
  STATUS_DISPATCHED  = 1
  STATUS_TRANSFERRED = 2
  STATUS_STARTED     = 3
  STATUS_WORK_DONE   = 4
  STATUS_SETTLED     = 5
  STATUS_IN_PROGRESS = 6
  STATUS_CANCELED    = 7


  state_machine :status, initial: :na do
    state :na, value: STATUS_NA
  end


  def init_state_machines
    initialize_state_machines
  end

  def next_events
    my_role == :prov ? next_provider_events : next_subcontractor_events
  end

  # State machine for ServiceCall subcontractor_status
  # status constant list:
  SUBCON_STATUS_NA          = 0
  SUBCON_STATUS_PENDING     = 1
  SUBCON_STATUS_ACCEPTED    = 2
  SUBCON_STATUS_REJECTED    = 3
  SUBCON_STATUS_TRANSFERRED = 4
  SUBCON_STATUS_IN_PROGRESS = 5
  SUBCON_STATUS_WORK_DONE   = 6
  SUBCON_STATUS_SETTLED     = 7
  SUBCON_STATUS_CANCELED    = 8
  SUBCON_STATUS_PAID        = 9

  state_machine :subcontractor_status, :initial => :na, namespace: 'subcon' do
    state :na, value: SUBCON_STATUS_NA
  end

  BILLING_STATUS_PENDING = 0
  BILLING_STATUS_PAID    = 1
  BILLING_STATUS_OVERDUE = 2

  state_machine :billing_status, initial: :pending, namespace: 'customer' do
    state :pending, value: BILLING_STATUS_PENDING
    state :paid, value: BILLING_STATUS_PAID do
      #validate :total_price_validation
    end
    state :overdue, value: BILLING_STATUS_OVERDUE do
      #validates_numericality_of :total_price
    end

    event :paid do
      transition :pending => :paid
    end

    event :overdue do
      transition :pending => :overdue
    end
  end

  def completed_on_text
    @completed_on_text || completed_on.try(:strftime, "%Y-%m-%d %H:%M:%S")

  end

  def save_completed_on_text
    self.completed_on = Time.zone.parse(@completed_on_text) if @completed_on_text.present?
  end

  def check_completed_on_text
    if @completed_on_text.present? && Time.zone.parse(@completed_on_text).nil?
      errors.add @completed_on_text, "cannot be parsed"
    end
  rescue ArgumentError
    errors.add @completed_on_text, "is out of range"
  end

  def started_on_text
    @started_on_text || started_on.try(:strftime, "%Y-%m-%d %H:%M:%S")

  end

  def save_started_on_text
    self.started_on = Time.zone.parse(@started_on_text) if @started_on_text.present?
  end

  def check_started_on_text
    if @started_on_text.present? && Time.zone.parse(@started_on_text).nil?
      errors.add @started_on_text, "cannot be parsed"
    end
  rescue ArgumentError
    errors.add @started_on_text, "is out of range"
  end

  def create_customer
    if provider
      self.customer = self.provider.customers.new(name:         new_customer,
                                                  address1:     address1,
                                                  address2:     address2,
                                                  country:      country,
                                                  city:         city,
                                                  state:        state,
                                                  zip:          zip,
                                                  phone:        phone,
                                                  mobile_phone: mobile_phone) if new_customer.present? && customer.nil?

    else
      self.customer = self.organization.customers.new(name:         new_customer,
                                                      address1:     address1,
                                                      address2:     address2,
                                                      country:      country,
                                                      city:         city,
                                                      state:        state,
                                                      zip:          zip,
                                                      phone:        phone,
                                                      mobile_phone: mobile_phone) if new_customer.present? && customer.nil?
    end
  end


  def before_create
    name = "#{customer.name} - #{address1}"
  end

  private
  def customer_belongs_to_provider
    errors.add(:customer, I18n.t('service_call.errors.customer_does_not_belong_to_provider')) unless !customer || customer.organization_id == provider_id
  end

  def total_price_validation
    errors.add :total_price, "is not a number" unless !total_price.nil? && total_price.instance_of?(BigDecimal)
  end


end

