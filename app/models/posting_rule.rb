# == Schema Information
#
# Table name: posting_rules
#
#  id           :integer         not null, primary key
#  agreement_id :integer
#  type         :string(255)
#  rate         :decimal(, )
#  rate_type    :string(255)
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#  properties   :hstore
#

class PostingRule < ActiveRecord::Base
  serialize :properties, ActiveRecord::Coders::Hstore

  validates_presence_of :agreement_id, :rate, :rate_type

  belongs_to :agreement

  def applicable?(event)
    true
  end

  def self.new_rule_from_params(type, params)
    unless type.nil?
      rule = type.classify.constantize.new(params)
    end

    raise "the 'type' parameter was not provided when creating a new agreement" if rule.nil?
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
end
