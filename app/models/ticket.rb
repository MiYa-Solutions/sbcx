# == Schema Information
#
# Table name: tickets
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
#  settlement_date      :datetime
#  name                 :string(255)
#  scheduled_for        :datetime
#  transferable         :boolean         default(FALSE)
#  allow_collection     :boolean         default(TRUE)
#  collector_id         :integer
#  collector_type       :string(255)
#  provider_status      :integer
#  work_status          :integer
#  re_transfer          :boolean
#

class Ticket < ActiveRecord::Base
  #attr_accessible :customer_id, :notes, :started_on, :completed_on, :completed_on_text, :started_on_text, :new_customer, :status_event, :subcontractor_id, :provider_id, :technician_id, :total_price
  belongs_to :customer, :inverse_of => :service_calls
  belongs_to :organization, :inverse_of => :service_calls
  belongs_to :subcontractor
  belongs_to :provider
  belongs_to :technician, class_name: User
  has_many :events, as: :eventable
  has_many :notifications, as: :notifiable
  has_many :boms do
    def build(params)
      unless params[:buyer].nil? || params[:buyer].empty?
        buyer = params[:buyer_type].classify.constantize.find(params[:buyer])
      end
      params.delete(:buyer)
      params.delete(:buyer_type)

      bom        = Bom.new(params)
      bom.buyer  = buyer
      bom.ticket = proxy_association.owner
      bom
    end
  end
  belongs_to :collector, :polymorphic => true
  has_many :appointments, as: :appointable

  scope :created_after, ->(prov, subcon, after) { where("provider_id = #{prov} AND subcontractor_id = #{subcon} and created_at > '#{after}'") }

  stampable

  # virtual attributes
  attr_writer :started_on_text, :completed_on_text, :scheduled_for_text, :company, :address1, :address2,
              :city, :state, :zip, :country, :phone, :mobile_phone, :work_phone, :email
  attr_accessor :new_customer

  # transform the dates before saving
  before_save :save_started_on_text
  before_save :save_completed_on_text
  before_save :save_scheduled_for_text
                                                            # create a new customer in case one was asked for
  before_validation :create_customer

  validate :check_completed_on_text, :check_started_on_text, :check_scheduled_for_text #, :customer_belongs_to_provider
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

  def completed_on_text
    @completed_on_text || completed_on.try(:strftime, "%B %d, %Y %H:%M")

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
    @started_on_text || started_on.try(:strftime, "%B %d, %Y %H:%M")

  end
  def scheduled_for_text
    @scheduled_for_text || started_on.try(:strftime, "%B %d, %Y %H:%M")

  end

  def save_scheduled_for_text
    self.scheduled_for = Time.zone.parse(@scheduled_for_text) if @scheduled_for_text.present?
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

  def check_scheduled_for_text
    if @scheduled_for_text.present? && Time.zone.parse(@scheduled_for_text).nil?
      errors.add @scheduled_for_text, "cannot be parsed"
    end
  rescue ArgumentError
    errors.add @scheduled_for_text, "is out of range"
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

  def validate_collector
    if organization.multi_user?
      self.errors.add :collector, "You must specify who collected the payment" unless self.collector
    else
      self.collector = organization.users.first
    end

  end

  # this validator runs only for a specific state of a service call
  def validate_subcon
    self.errors.add :subcontractor, I18n.t('activerecord.errors.ticket.attributes.subcontractor.blank') unless subcontractor
    self.errors.add :subcontractor, I18n.t('activerecord.errors.ticket.self_transfer') if subcontractor_id == organization_id
  end

  def validate_circular_transfer
    subcontractor_id != organization_id &&
        Ticket.where("ref_id = #{ref_id} AND organization_id = #{subcontractor_id}").size > 0
  end

  # this validator runs only for a specific state of a service call
  def validate_technician
    if organization.multi_user? && !transferred?
      self.errors.add :technician, "You must specify a technician" unless self.technician
    else
      self.technician = organization.users.first unless transferred?
    end

  end


  def before_create
    self.name = "#{customer.name} - #{address1}"
  end

  def total_cost

    total = Money.new(0)
    boms.each do |bom|
      total += bom.total_cost
    end

    total
  end

  def total_price
    total = Money.new(0)
    boms.each do |bom|
      total += bom.total_price
    end
    total
  end

  def total_profit
    total_price - total_cost
  end

  def provider_cost
    total = Money.new(0)
    boms.each do |bom|
      total += bom.total_cost if bom.buyer.becomes(Provider) == provider
    end
    total

  end

  def subcontractor_cost
    total = Money.new(0)
    boms.each do |bom|
      total += bom.total_cost if bom.buyer.becomes(Subcontractor) == subcontractor
    end
    total

  end

  def technician_cost
    total = Money.new(0)
    boms.each do |bom|
      total += bom.total_cost if bom.buyer == technician
    end
    total

  end

  def counterparty
    case my_role
      when :prov
        subcontractor
      when :subcon
        provider
      else
        raise "Unexpected role for #{self.class.name} id: #{self.id}"
    end
  end

  private
  def customer_belongs_to_provider
    errors.add(:customer, I18n.t('service_call.errors.customer_does_not_belong_to_provider')) unless !customer || customer.organization_id == provider_id
  end

  def total_price_validation
    errors.add :total_price, "is not a number" unless !total_price.nil? && total_price.instance_of?(BigDecimal)
  end

end
