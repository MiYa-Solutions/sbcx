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

class PostingRule < ActiveRecord::Base
  serialize :properties, ActiveRecord::Coders::Hstore

  validates_presence_of :agreement_id, :rate, :rate_type, :type
  validates_numericality_of :rate

  validate :ensure_state_before_change

  belongs_to :agreement

  def applicable?(event)
    true
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

  def rate_types
    [:percentage]
  end

  def get_amount(ticket)
    raise "Did you forget to implement the get_amount method for #{self.class}?"
  end


  protected
  def ensure_state_before_change
    errors.add :agreement, I18n.t('activerecord.errors.posting_rule.change_active_project') if agreement.try(:active?) || agreement.try(:canceled?)
  end
end
