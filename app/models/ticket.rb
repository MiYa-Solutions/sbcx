# == Schema Information
#
# Table name: tickets
#
#  id                       :integer          not null, primary key
#  customer_id              :integer
#  notes                    :text
#  started_on               :datetime
#  organization_id          :integer
#  completed_on             :datetime
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  status                   :integer
#  subcontractor_id         :integer
#  technician_id            :integer
#  provider_id              :integer
#  subcontractor_status     :integer
#  type                     :string(255)
#  ref_id                   :integer
#  creator_id               :integer
#  updater_id               :integer
#  settled_on               :datetime
#  billing_status           :integer
#  settlement_date          :datetime
#  name                     :string(255)
#  scheduled_for            :datetime
#  transferable             :boolean          default(TRUE)
#  allow_collection         :boolean          default(TRUE)
#  collector_id             :integer
#  collector_type           :string(255)
#  provider_status          :integer
#  work_status              :integer
#  re_transfer              :boolean          default(TRUE)
#  payment_type             :string(255)
#  subcon_payment           :string(255)
#  provider_payment         :string(255)
#  company                  :string(255)
#  address1                 :string(255)
#  address2                 :string(255)
#  city                     :string(255)
#  state                    :string(255)
#  zip                      :string(255)
#  country                  :string(255)
#  phone                    :string(255)
#  mobile_phone             :string(255)
#  work_phone               :string(255)
#  email                    :string(255)
#  subcon_agreement_id      :integer
#  provider_agreement_id    :integer
#  tax                      :float            default(0.0)
#  subcon_fee_cents         :integer          default(0), not null
#  subcon_fee_currency      :string(255)      default("USD"), not null
#  properties               :hstore
#  external_ref             :string(255)
#  subcon_collection_status :integer
#  prov_collection_status   :integer
#

class Ticket < ActiveRecord::Base
  include CustomerCreator
  include InvoiceableTicket
  include Forms::TicketProjectForm

  serialize :properties, ActiveRecord::Coders::Hstore
  monetize :subcon_fee_cents
  belongs_to :project
  belongs_to :organization, :inverse_of => :service_calls
  belongs_to :subcontractor
  belongs_to :provider
  belongs_to :payment
  belongs_to :technician, class_name: User
  has_many :events, as: :eventable, :order => 'id DESC'
  has_many :custom_events, as: :eventable, :order => 'id DESC', class_name: 'CustomEvent', table_name: 'events'
  has_many :notifications, as: :notifiable
  has_many :boms do
    def build(params)
      unless params[:buyer_id].nil? || params[:buyer_id].empty?
        buyer = params[:buyer_type].classify.constantize.find(params[:buyer_id])
      end
      params.delete(:buyer_id)
      params.delete(:buyer_type)

      bom        = Bom.new(params)
      bom.buyer  = buyer
      bom.ticket = proxy_association.owner
      bom
    end
  end
  belongs_to :collector, :polymorphic => true
  has_many :appointments, as: :appointable, finder_sql: proc { "SELECT appointments.* FROM appointments WHERE appointments.appointable_id = #{id} AND appointments.appointable_type = '#{self.class.name}'" }
  has_many :accounting_entries

  has_many :taggings, as: :taggable
  has_many :tags, through: :taggings
  belongs_to :subcon_agreement, class_name: 'Agreement'
  belongs_to :provider_agreement, class_name: 'Agreement'

  alias_method :entries, :accounting_entries

  scope :created_after, ->(prov, subcon, after) { where("provider_id = #{prov.id} AND subcontractor_id = #{subcon.id} and created_at > '#{after}'") }
  scope :affiliated_jobs, ->(org, affiliate) { where(organization_id: org.id) & (where(provider_id: affiliate.id) | where(subcontractor_id: affiliate.id)) }
  scope :open_affiliated_jobs, ->(org, affiliate) { (where(organization_id: org.id) & (where(provider_id: affiliate.id) | where(subcontractor_id: affiliate.id))).where('tickets.status NOT IN (?)', [ServiceCall::STATUS_CANCELED, ServiceCall::STATUS_CLOSED]) }
  scope :customer_jobs, ->(org, customer) { where(organization_id: org.id).where(customer_id: customer.id) }

  stampable

  ### VIRTUAL ATTRIBUTES
  attr_writer :started_on_text, :completed_on_text, :scheduled_for_text
  attr_accessor :system_update
  attr_accessor :payment_type
  attr_accessor :payment_notes

  attr_writer :tag_list

  # synch the associated contractor and subcontractor tickets
  before_update TicketSynchService.new

  ### TRANSFORM THE DATES BEFORE SAVING
  before_save :save_started_on_text
  before_save :save_completed_on_text
  before_save :save_scheduled_for_text
  before_save :assign_tags
  after_save :create_appointment

  # create a new customer in case one was asked for
  before_create :set_name

  validate :check_completed_on_text, :check_started_on_text, :check_scheduled_for_text #, :customer_belongs_to_provider
  validates_presence_of :organization, :provider
  validates_presence_of :customer, if: "new_customer.nil? ||  new_customer.empty?"
  validate :check_subcon_agreement, :check_provider_agreement
  validates_numericality_of :tax
  validates_email_format_of :email, allow_nil: true, allow_blank: true

  validates_uniqueness_of :external_ref, scope: :organization_id, allow_blank: false, if: :validate_external_ref?
  validates_presence_of :external_ref, if: :validate_external_ref?

  validate :check_project_owner, if: ->(t) { t.project_id }

  accepts_nested_attributes_for :customer
  accepts_nested_attributes_for :custom_events

  ### state machine states constants

  STATUS_NEW         = 0000
  STATUS_OPEN        = 0001
  STATUS_TRANSFERRED = 0002
  STATUS_CLOSED      = 0003
  STATUS_CANCELED    = 0004

  scope :new_status, -> { where("tickets.status = ?", STATUS_NEW) }
  scope :open_status, -> { where("tickets.status = ?", STATUS_OPEN) }
  scope :transferred_status, -> { where("tickets.status = ?", STATUS_TRANSFERRED) }
  scope :closed_status, -> { where("tickets.status = ?", STATUS_CLOSED) }
  scope :canceled_status, -> { where("tickets.status = ?", STATUS_CANCELED) }

  def self.find_in_batches(scope, batch_size=50, &block)
    #find_each will batch the results instead of getting all in one go
    scope.find_each(batch_size: batch_size) do |transaction|
      yield transaction
    end
  end

  def customer_account
    Account.where(accountable_id: customer_id, accountable_type: 'Customer').first
  end

  def to_csv_row


    CSV::Row.new(
        [
            :id, :type, :name, :ref_id, :external_ref, :my_profit, :total_cost, :total_price, :adjustment_amount, :tax, :tax_amount, :total, :customer_balance, :customer_name,
            :address1, :address2, :city, :state, :country, :zip, :started_on,
            :completed_on, :created_at, :updated_at, :status, :work_status, :billing_status, :provider_status, :subcontractor_status,
            :subcon_collection_status, :provider_collection_status, :technician_name, :provider_name, :subcontractor_name, :creator,
            :notes
        ],
        [
            id,
            type,
            name,
            ref_id,
            external_ref,
            my_profit,
            total_cost,
            total_price,
            adj_amount,
            tax,
            tax_amount,
            total,
            customer_balance,
            customer.name,
            address1,
            address2,
            city,
            state,
            country,
            zip,
            started_on,
            completed_on,
            created_at,
            updated_at,
            human_status_name,
            human_work_status_name,
            defined?(billing_status_name) ? human_billing_status_name : '',
            defined?(provider_status_name) ? human_provider_status_name : '',
            defined?(subcontractor_status_name) ? human_subcontractor_status_name : '',
            defined?(subcon_collection_status_name) ? human_subcon_collection_status_name : '',
            defined?(prov_collection_status_name) ? human_prov_collection_status_name : '',
            technician.try(:name),
            provider.name,
            subcontractor.try(:name),
            creator.name,
            notes]
    )
  end

  def subcon_balance
    if transferred? # this is an abstract class and so transferred is assumed to be implemented by the subclasses
      affiliate_balance(subcontractor)
    else
      Money.new_with_amount(0)
    end

  end

  def customer_attributes
    {
        name:         customer_name,
        address1:     address1,
        address2:     address2,
        country:      country,
        city:         city,
        state:        state,
        zip:          zip,
        phone:        phone,
        email:        email,
        mobile_phone: mobile_phone
    }

  end


  def customer_balance
    account = Account.for_customer(customer).first
    if account && AccountingEntry.where(account_id: account.id, ticket_id: self.id).size > 0
      # todo make the below calculation support multiple currencies
      Money.new(AccountingEntry.where(account_id: account.id, ticket_id: self.id).sum(:amount_cents), AccountingEntry.where(account_id: account.id, ticket_id: self.id).first.amount_currency)
    else
      Money.new_with_amount(0)
    end

  end

  def affiliate_balance(affiliate)
    account = Account.for_affiliate(self.organization, affiliate).first
    if account && AccountingEntry.where(account_id: account.id, ticket_id: self.id).size > 0
      # todo make the below calculation support multiple currencies
      Money.new(AccountingEntry.where(account_id: account.id, ticket_id: self.id).sum(:amount_cents), AccountingEntry.where(account_id: account.id, ticket_id: self.id).first.amount_currency)
    else
      Money.new_with_amount(0)
    end

  end

  def provider_balance
    if provider != organization
      affiliate_balance(provider)
    else
      Money.new_with_amount(0)
    end
  end

  def html_notes
    self.notes.gsub(/\n/, '<br/>')
  end

  def tax_amount
    the_tax = tax ? tax : 0.0
    total_price * (the_tax / 100.0)
  end

  def total
    if canceled?
      Money.new(0)
    else
      total_price + tax_amount + adj_amount
    end
  end

  def adj_amount
    Money.new(AdjustmentEntry.where(account_id: customer.account.id, ticket_id: self.id).sum(:amount_cents))
  end

  def completed_on_text
    @completed_on_text || completed_on.try(:strftime, "%B %d, %Y %H:%M")

  end

  def save_completed_on_text
    self.completed_on = Time.zone.parse(@completed_on_text) if @completed_on_text.present?
  end

  def check_completed_on_text
    if @completed_on_text.present? && Time.zone.parse(@completed_on_text).nil?
      errors.add :completed_on_text, "cannot be parsed"
    end
  rescue ArgumentError, RangeError
    errors.add :completed_on_text, "is out of range"
  end

  def started_on_text
    @started_on_text || started_on.try(:strftime, "%a %B %d, %Y %H:%M")

  end

  def scheduled_for_text
    @scheduled_for_text || scheduled_for.try(:strftime, "%a %B %d, %Y %H:%M")

  end

  def save_scheduled_for_text
    self.scheduled_for = Time.zone.parse(@scheduled_for_text) if @scheduled_for_text.present?
  end

  def save_started_on_text
    self.started_on = Time.zone.parse(@started_on_text) if @started_on_text.present?
  end

  def check_started_on_text
    if @started_on_text.present? && Time.zone.parse(@started_on_text).nil?
      errors.add :started_on_text, "cannot be parsed"
    end
  rescue ArgumentError, RangeError
    errors.add :started_on_text, "is out of range"
  end

  def check_scheduled_for_text
    if @scheduled_for_text.present? && Time.zone.parse(@scheduled_for_text).nil?
      errors.add :scheduled_for_text, "cannot be parsed"
    end
  rescue ArgumentError, RangeError
    errors.add :scheduled_for_text, "is out of range"
  end


  def validate_payment
    self.errors.add :payment_type, "You must indicate the type of payment" unless self.payment_type
  end

  def validate_collector
    if organization.multi_user?
      self.errors.add :collector, "You must specify who collected the payment" unless self.collector
    else
      self.collector = organization.users.first
    end

  end

  def payment_money
    Money.new(self.payment_amount.to_f * 100)
  end

  # this validator runs only for a specific state of a service call
  def validate_subcon
    self.errors.add :subcontractor, I18n.t('activerecord.errors.ticket.attributes.subcontractor.blank') unless subcontractor
    self.errors.add :subcontractor, I18n.t('activerecord.errors.ticket.self_transfer') if subcontractor_id == organization_id
  end

  def validate_circular_transfer
    subcontractor_id != organization_id && subcontractor_id != provider_id &&
        Ticket.where("ref_id = #{ref_id} AND organization_id = #{subcontractor_id}").size > 0
  end

  # this validator runs only for a specific state of a service call
  def validate_technician
    if organization.multi_user? && !transferred? && !canceled? && !changed_from_transferred?
      self.errors.add :technician, "You must specify a technician" unless self.technician
    else
      self.technician = organization.users.first unless (transferred? || canceled?)
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

  def subcon_entries
    if subcontractor
      acc = Account.for_affiliate(organization, subcontractor).first
      acc ? entries.by_acc(acc) : AccountingEntry.none
    else
      AccountingEntry.none
    end
  end

  def active_subcon_entries
    subcon_entries.where('status NOT in (?)', [AccountingEntry::STATUS_CLEARED, AccountingEntry::STATUS_DEPOSITED, ConfirmableEntry::STATUS_CONFIRMED, AdjustmentEntry::STATUS_CANCELED, AdjustmentEntry::STATUS_ACCEPTED])
  end


  def provider_entries
    if provider
      acc = Account.for_affiliate(organization, provider).first
      acc ? entries.by_acc(acc) : AccountingEntry.none
    else
      AccountingEntry.none
    end
  end

  def active_provider_entries
    provider_entries.where('status NOT in (?)', [AccountingEntry::STATUS_CLEARED, AccountingEntry::STATUS_DEPOSITED, ConfirmableEntry::STATUS_CONFIRMED, AdjustmentEntry::STATUS_CANCELED, AdjustmentEntry::STATUS_ACCEPTED])
  end

  def customer_entries
    if customer
      acc = Account.for_customer(customer).first
      acc ? entries.by_acc(acc) : AccountingEntry.none
    else
      AccountingEntry.none
    end
  end

  def active_customer_entries
    customer_entries.where('status NOT in (?)', [AccountingEntry::STATUS_CLEARED, CustomerPayment::STATUS_REJECTED, AdjustmentEntry::STATUS_CANCELED, AdjustmentEntry::STATUS_ACCEPTED])
  end


  def counterparty
    case my_role
      when :prov
        subcontractor ? [subcontractor] : nil
      when :subcon
        [provider]
      when :broker
        [provider, subcontractor]
      else
        raise "Unexpected role for #{self.class.name} id: #{self.id}"
    end
  end

  def tag_list
    @tag_list || tags.map(&:name).join(", ")
  end

  def transfer_props
    subcon_transfer_props | provider_transfer_props
  end

  def subcon_transfer_props
    subcon_agreement ? subcon_agreement.rules.map { |rule| rule.get_transfer_props(self) } : [AffiliatePostingRule::TransferProperties.new]
  end

  def provider_transfer_props
    provider_agreement ? provider_agreement.rules.map { |rule| rule.get_transfer_props(self) } : [AffiliatePostingRule::TransferProperties.new]
  end

  def properties=(hash = {})
    ##
    # the commented code is used to filter out none valid props, it is commented as it is done in using strong paramenters
    # in the controller. The code is left here in case we decide to move the implementation to the model
    ##

    #clean_hash = {}
    #white_list = transfer_props.map(&:attribute_names).flatten
    #hash.each do |key, value|
    #  clean_hash = clean_hash.merge key => value if white_list.include? key.to_sym
    #end
    #write_attribute(:properties, clean_hash)

    write_attribute(:properties, properties.merge(hash))
    Rails.logger.debug { "wrote properties attribute for ticket.\nproperties: #{self.properties}\nTicket: #{self.inspect}" }

  end

  def subcon_ticket
    Ticket.where(organization_id: subcontractor_id).where(ref_id: ref_id).first
  end

  def contractor_ticket
    @contractor_ticket ||= MyServiceCall.where(id: ref_id).first
  end

  def subcon_chain_ids
    res = []
    unless subcontractor_id.nil? || subcontractor_id == organization_id
      res << subcontractor_id
      res = res + subcon_ticket.subcon_chain_ids
    end
    res
  end

  def provider_chain_ids
    res = []
    unless provider_id.nil? || provider_id == organization_id
      res << provider_id
      res = res + provider_ticket.provider_chain_ids
    end
    res
  end


  protected

  def check_project_owner
    if project.organization_id != self.organization_id
      raise TicketExceptions::InvalidAssociation.new(I18n.t('exceptions.ticket.invalid_project',
                                                              org_name:   organization.name,
                                                              ticket_id:   self.id,
                                                              project_id: project_id))
    end
  end

  def check_subcon_agreement
    unless self.subcon_agreement.nil?
      errors.add :subcon_agreement, "Invalid Subcontracting Agreement: the agreement must specify the subcontractor as the counterparty" if subcon_agreement.counterparty.becomes(Organization) != self.subcontractor.becomes(Organization)
    end
  end

  def check_provider_agreement
    unless self.provider_agreement.nil?
      errors.add :provider_agreement, "Invalid Subcontracting Agreement: the agreement must specify the provider as the organization" if provider_agreement.organization.becomes(Organization) != self.provider.try(:becomes, Organization)
    end
  end

  # Assigns tags from a comma separated tag list
  def assign_tags
    if @tag_list
      self.taggings.each { |tagging| tagging.destroy }
      self.tags = @tag_list.split(/,/).uniq.map do |name|
        Tag.where(name: name.strip, organization_id: organization_id).first || Tag.create(:name => name.strip, organization_id: organization_id)
      end
    end
  end

  def self.tagged_with(org_id, name)
    Tag.find_by_organization_id_and_name!(org_id, name).taggables
  end

  alias_method :affiliate, :counterparty

  def set_name
    if self.name.nil?
      self.name = "#{self.address1}: #{self.tags.map(&:name).join(", ")}"
    end
  end

  private
  def customer_belongs_to_provider
    errors.add(:customer, I18n.t('service_call.errors.customer_does_not_belong_to_provider')) unless !customer || customer.organization_id == provider_id
  end

  def total_price_validation
    errors.add :total_price, "is not a number" unless !total_price.nil? && total_price.instance_of?(BigDecimal)
  end

  def create_appointment
    appointments << Appointment.new(organization: organization,
                                    starts_at:    self.scheduled_for,
                                    ends_at:      self.scheduled_for + 3600,
                                    title:        I18n.t('appointment.auto_title', id: self.ref_id),
                                    description:  I18n.t('appointment.auto_description', id: self.ref_id)) if self.scheduled_for_changed?
  end

  def changed_from_transferred?
    changes[:status] && changes[:status][0] == ServiceCall::STATUS_TRANSFERRED
  end

  def validate_external_ref?
    self.organization && self.organization.settings.validate_job_ext_ref?
  end

end
