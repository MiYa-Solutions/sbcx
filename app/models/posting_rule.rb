# == Schema Information
#
# Table name: posting_rules
#
#  id             :integer          not null, primary key
#  agreement_id   :integer
#  type           :string(255)
#  rate           :decimal(, )
#  rate_type      :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  properties     :hstore
#  time_bound     :boolean          default(FALSE)
#  sunday         :boolean          default(FALSE)
#  monday         :boolean          default(FALSE)
#  tuesday        :boolean          default(FALSE)
#  wednesday      :boolean          default(FALSE)
#  thursday       :boolean          default(FALSE)
#  friday         :boolean          default(FALSE)
#  saturday       :boolean          default(FALSE)
#  sunday_from    :time
#  monday_from    :time
#  tuesday_from   :time
#  wednesday_from :time
#  thursday_from  :time
#  friday_from    :time
#  saturday_from  :time
#  sunday_to      :time
#  monday_to      :time
#  tuesday_to     :time
#  wednesday_to   :time
#  thursday_to    :time
#  friday_to      :time
#  saturday_to    :time
#

# == Schema Information
#
# Table name: posting_rules
#
#  id             :integer          not null, primary key
#  agreement_id   :integer
#  type           :string(255)
#  rate           :decimal(, )
#  rate_type      :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  properties     :hstore
#  time_bound     :boolean          default(FALSE)
#  sunday         :boolean          default(FALSE)
#  monday         :boolean          default(FALSE)
#  tuesday        :boolean          default(FALSE)
#  wednesday      :boolean          default(FALSE)
#  thursday       :boolean          default(FALSE)
#  friday         :boolean          default(FALSE)
#  saturday       :boolean          default(FALSE)
#  sunday_from    :time
#  monday_from    :time
#  tuesday_from   :time
#  wednesday_from :time
#  thursday_from  :time
#  friday_from    :time
#  saturday_from  :time
#  sunday_to      :time
#  monday_to      :time
#  tuesday_to     :time
#  wednesday_to   :time
#  thursday_to    :time
#  friday_to      :time
#  saturday_to    :time
#
require 'hstore_setup_methods'
class PostingRule < ActiveRecord::Base
  # creates the standard methods for an attribute that is stored in hstore column
  extend HstoreSetupMethods

  has_paper_trail meta: { assoc_id: :agreement_id }

  def agreement_version_id

  end

  # define hstore properties methods
  #%w[cheque_rate cheque_rate_type credit_rate credit_rate_type cash_rate cash_rate_type amex_rate amex_rate_type].each do |key|
  %w[ cheque_rate
    cheque_rate_type
    credit_rate
    credit_rate_type
    cash_rate
    cash_rate_type
    amex_rate
    amex_rate_type   ].each do |key, value|
    setup_hstore_attr(key)
  end


  serialize :properties, ActiveRecord::Coders::Hstore

  validates_presence_of :agreement, :type

  validate :ensure_state_before_change

  belongs_to :agreement

  def applicable?(event)
    true
  end

  def rate_types
    [:percentage]
  end

  def self.new_rule_from_params(type, params)
    unless type.nil?
      rule = type.classify.constantize.new(params)
    end

    raise "the 'type' parameter was not provided when creating a new posting rule" if rule.nil?
    rule

  end

  def self.new_posting_rule(type, agreement_id = nil)
    unless type.nil?
      posting_rule              = type.classify.constantize.new
      posting_rule.agreement_id = agreement_id
    end

    raise "the 'type' parameter was not provided when creating a new posting rule" if posting_rule.nil?
    posting_rule

  end

  # the main method for getting the accounting entries applicable for a certain event and account
  def get_entries(event, account)
    @ticket  = event.eventable
    @event   = event
    @account = account

    case event.class.name
      when ServiceCallCompletedEvent.name, ServiceCallCompleteEvent.name
        charge_entries
      when ScSubconSettleEvent.name, ScSubconSettledEvent.name, ScProviderSettleEvent.name, ScProviderSettledEvent.name
        settlement_entries
      when ServiceCallCancelEvent.name, ServiceCallCanceledEvent.name, ScProviderCanceledEvent.name
        cancellation_entries
      when ScCollectEvent.name, ScCollectedEvent.name, ScCollectedByEmployeeEvent.name
        collection_entries
      when ServiceCallPaidEvent.name, ScProviderCollectedEvent.name
        payment_entries
      when ScWorkReopenEvent.name
        reopen_entries
      else
        raise "Unexpected Event (#{event.class.name}) to be processed by the posting rule (#{self.class.name})"
    end
  end

  def cash_fee
    case cash_rate_type
      when 'percentage'
        @event.amount* (cash_rate.delete(',').to_f / 100.0)
      when 'flat_fee'
        Money.new_with_amount(cash_rate.delete(',').to_f)
      else
        Money.new_with_amount(0)
    end
  end

  def credit_fee
    case credit_rate_type
      when 'percentage'
        @event.amount * (credit_rate.delete(',').to_f / 100.0)
      when 'flat_fee'
        Money.new_with_amount(credit_rate.delete(',').to_f)
      else
        Money.new_with_amount(0)
    end
  end

  def amex_fee
    case amex_rate_type
      when 'percentage'
        @event.amount * (amex_rate.delete(',').to_f / 100.0)
      when 'flat_fee'
        Money.new_with_amount(amex_rate.delete(',').to_f)
      else
        Money.new_with_amount(0)
    end
  end

  def cheque_fee
    case cheque_rate_type
      when 'percentage'
        @event.amount * (cheque_rate.delete(',').to_f / 100.0)
      when 'flat_fee'
        Money.new_with_amount(cheque_rate.delete(',').to_f)
      else
        Money.new_with_amount(0)
    end
  end


  protected
  def ensure_state_before_change
    errors.add :agreement, I18n.t('activerecord.errors.posting_rule.change_active_project') if agreement.try(:active?) || agreement.try(:canceled?)
  end
end
