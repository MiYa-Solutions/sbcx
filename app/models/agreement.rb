# == Schema Information
#
# Table name: agreements
#
#  id                :integer         not null, primary key
#  name              :string(255)
#  counterparty_id   :integer
#  organization_id   :integer
#  description       :text
#  created_at        :datetime        not null
#  updated_at        :datetime        not null
#  status            :integer
#  counterparty_type :string(255)
#  type              :string(255)
#  creator_id        :integer
#  updater_id        :integer
#  starts_at         :datetime
#  ends_at           :datetime
#  payment_terms     :integer
#

class Agreement < ActiveRecord::Base

  belongs_to :organization
  belongs_to :counterparty, polymorphic: true
  has_many :events, as: :eventable
  has_many :notifications, as: :notifiable
  has_many :posting_rules
  has_many :payments

  accepts_nested_attributes_for :payments

  stampable

  validates_presence_of :organization, :counterparty, :creator



  # State machine  for Agreement status
  STATUS_DRAFT = 0

  state_machine :status, :initial => :draft do
    state :draft, value: STATUS_DRAFT
    after_failure do |agreement, transition|
      Rails.logger.debug { "Organization Agreement status state machine failure. Agreement errors : \n" + agreement.errors.messages.inspect + "\n The transition: " +transition.inspect }
    end
  end

  scope :org_agreements, ->(org_id) { where(:organization_id => org_id) }
  scope :cparty_agreements, ->(org_id) { where(:counterparty_id => org_id) }
  scope :my_agreements, ->(org_id) { (org_agreements(org_id) | (cparty_agreements(org_id))) }
  scope :our_agreements, ->(org_id, otherparty_id) { (org_agreements(org_id).where(:counterparty_id => otherparty_id) | (cparty_agreements(org_id).where(:organization_id => otherparty_id))) }

  attr_accessor :change_reason

  def self.new_agreement(type, org, other_party_id = nil, other_party_role = nil)

    if type.nil? || type.empty?
      agreement               = Agreement.new
      agreement.errors[:type] = t('activerecord.errors.agreement.no_type')
    else # create the agreement subclass which is expected to be underscored

      agreement = type.camelize.constantize.new

      if other_party_role.nil? # if the role of the other party is not specified, assume counterparty
        org.agreements << agreement
      else

        case other_party_role
          when "organization"
            agreement.organization_id = other_party_id
            agreement.counterparty    = org
          #org.reverse_agreements << agreement
          else
            agreement.counterparty_id = other_party_id
            agreement.organization    = org
          #org.agreements << agreement
        end

      end

    end
    agreement
  end

  def self.new_agreement_from_params(type, params)
    unless type.nil?
      agreement = type.camelize.constantize.new(params)
    end

    raise "the 'type' parameter was not provided when creating a new agreement" if agreement.nil?
    agreement

  end

  def find_posting_rules(event)
    rules = []
    posting_rules.each do |rule|
      rules << rule if rule.applicable?(event)
    end
    rules
  end


end
