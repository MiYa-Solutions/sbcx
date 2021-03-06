# == Schema Information
#
# Table name: agreements
#
#  id                :integer          not null, primary key
#  name              :string(255)
#  counterparty_id   :integer
#  organization_id   :integer
#  description       :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  status            :integer
#  counterparty_type :string(255)
#  type              :string(255)
#  creator_id        :integer
#  updater_id        :integer
#  starts_at         :datetime
#  ends_at           :datetime
#  payment_terms     :string(255)
#

class Agreement < ActiveRecord::Base


  belongs_to :organization, inverse_of: :agreements
  belongs_to :counterparty, polymorphic: true
  has_many :events, as: :eventable, :order => 'id DESC'
  has_many :notifications, as: :notifiable
  has_many :posting_rules
  alias_method :rules, :posting_rules
  has_many :payments

  accepts_nested_attributes_for :payments

  stampable
  has_paper_trail if: ->(agr) { agr.status_changed? }

  validates_presence_of :organization, :counterparty, :creator, :name

  attr_writer :ends_at_text
  before_save :save_ends_on_text

  # State machine  for Agreement status
  STATUS_DRAFT            = 10000
  STATUS_APPROVED_PENDING = 10001
  STATUS_ACTIVE           = 10002
  STATUS_CANCELED         = 10003
  STATUS_REPLACED         = 10004

  state_machine :status, :initial => :draft do
    state :draft, value: STATUS_DRAFT
    state :active, value: STATUS_ACTIVE
    state :canceled, value: STATUS_CANCELED

    after_failure do |agreement, transition|
      Rails.logger.debug { "#{agreement.class.name} status state machine failure. Agreement errors : \n" + agreement.errors.messages.inspect + "\n The transition: " +transition.inspect }
    end

    after_transition any => :active do |agr|
      agr.starts_at = Time.zone.now unless agr.starts_at
      agr.save
    end
  end

  scope :org_agreements, ->(org_id) { where(:organization_id => org_id) }
  scope :cparty_agreements, ->(org_id) { where(:counterparty_id => org_id) }
  scope :my_agreements, ->(org_id) { (org_agreements(org_id) | (cparty_agreements(org_id))) }
  scope :our_agreements, ->(org, otherparty) { (org_agreements(org.id).where(:counterparty_id => otherparty.id).where(counterparty_type: otherparty.class.name) | (cparty_agreements(org.id).where(:organization_id => otherparty.id).where(counterparty_type: otherparty.class.name))) }
  scope :sibling_active_agreements, ->(agreement) { org_agreements(agreement.organization_id).where("counterparty_id = #{agreement.counterparty_id} AND type = '#{agreement.type}' AND status = #{Agreement::STATUS_ACTIVE}") - where(id: agreement.organization_id) }
  attr_accessor :change_reason

  def self.new_agreement(type, org, other_party_id = nil, other_party_role = nil, name = nil)

    if type.nil? || type.empty?
      agreement               = Agreement.new(name: name)
      agreement.errors[:type] = t('activerecord.errors.agreement.attributes.type.blank')
    else # create the agreement subclass which is expected to be underscored

      agreement      = type.camelize.constantize.new
      agreement.name = name

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

  def check_replacement_agreement
    Agreement.sibling_active_agreements(self).each do |agr|
      errors.add :starts_at, "you must set an end date for your active agreement before approving this agreement" if agr.ends_at.nil?
      errors.add :starts_at, "The end date of the current has to be set prior to the start date of this agreement" if agr.ends_at.present? && agr.ends_at >= self.starts_at

    end
  end

  def ends_at_text
    @ends_at_text || ends_at.nil? ? "" : I18n.l(ends_at)
  end

  def self.payment_options
    { cod: 0, net_10: 10, net_15: 15, net_30: 30, net_60: 60, net_90: 90 }
  end
  def self.default_payment_term
    :net_15
  end

  def get_transfer_props
    rules.map(&:get_transfer_props)
  end

  def human_payment_terms
    I18n.t("agreement.payment_options.#{payment_terms}")
  end

  def attr_changed_from_prev_ver?(attr)
    previous_version.nil? ? false : previous_version[attr] != self[attr]
  end

  def rules_changed_from_prev_ver?
    if self.live?
      cut_off_date = self.versions.size > 0 ? self.versions.last.created_at : self.created_at
    else
      cut_off_date = self.version.previous.nil? ? self.created_at : self.version.previous.try(:created_at)
    end

    PaperTrail::Version.where(item_type: 'PostingRule', assoc_id: self.id).
        where('created_at > ?', cut_off_date).size > 0

  end

  def changed_since_prev_version?
    AgrVersionDiffHelper.new.agr_diff_attrs.each do |attr|
      return true if  attr_changed_from_prev_ver? attr
    end

    return true if rules_changed_from_prev_ver?

    false
  end

  def last_version
    self.previous_version
  end

  def before_last_version
    self.previous_version.try(:previous_version) || last_version
  end

  def version_posting_rules
    self.live? ? posting_rules : rules_for_version(self.version)
  end


  private

  def save_ends_on_text
    self.ends_at = Time.zone.parse(@ends_at_text) if @ends_at_text.present?

  end

  protected
  def check_rules
    errors.add :posting_rules, "Can't activate agreement without posting rules" unless rules.size > 0
  end


end
