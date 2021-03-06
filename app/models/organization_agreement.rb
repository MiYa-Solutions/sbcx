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

class OrganizationAgreement < Agreement

  has_many :subcon_tickets, class_name: 'Ticket', foreign_key: 'subcon_agreement_id'
  has_many :prov_tickets, class_name: 'Ticket', foreign_key: 'provider_agreement_id'

                                # first we will define the organization state values
  STATUS_PENDING_ORG_APPROVAL    = 11000
  STATUS_PENDING_CPARTY_APPROVAL = 11001
  STATUS_REJECTED_BY_ORG         = 11002
  STATUS_REJECTED_BY_CPARTY      = 11003

  validate :ensure_state_before_change
  validate :end_date_validation #, if: ->(agr) { agr.ends_at_changed? }

  # The state machine definitions
  state_machine :status, :initial => :draft do
    state :draft, value: STATUS_DRAFT
    state :active, value: STATUS_ACTIVE do
      validate ->(agr) { agr.check_rules }
      validates_presence_of :payment_terms
    end
    state :pending_org_approval, value: STATUS_PENDING_ORG_APPROVAL do

      validates_presence_of :posting_rules, :payment_terms
    end
    state :pending_cparty_approval, value: STATUS_PENDING_CPARTY_APPROVAL do

      validates_presence_of :posting_rules, :payment_terms
    end
    state :rejected_by_org, value: STATUS_REJECTED_BY_ORG do

      validates_presence_of :posting_rules, :payment_terms
    end
    state :rejected_by_cparty, value: STATUS_REJECTED_BY_CPARTY do

      validates_presence_of :posting_rules, :payment_terms
    end
    state :canceled, value: STATUS_CANCELED
    state :replaced, value: STATUS_REPLACED


    # create the accounts after activating the agreement
    after_transition any => :active do |agreement, transition|
      agreement.finalize_activation
    end


    event :submit_for_approval do
      transition :draft => :pending_cparty_approval, if: ->(agreement) { agreement.creator.organization == agreement.organization && agreement.counterparty.subcontrax_member? }
      transition :draft => :pending_org_approval, if: ->(agreement) { agreement.creator.organization == agreement.counterparty && agreement.organization.subcontrax_member? }
    end

    event :activate do
      transition :draft => :active, unless: ->(agreement) { agreement.organization.subcontrax_member? }
      transition :draft => :active, unless: ->(agreement) { agreement.counterparty.subcontrax_member? }
    end

    event :submit_change do
      transition [:pending_org_approval, :rejected_by_cparty] => :pending_cparty_approval
      transition [:pending_cparty_approval, :rejected_by_org] => :pending_org_approval
    end

    event :accept do
      transition [:pending_org_approval, :pending_cparty_approval] => :active, unless: ->(agreement) { agreement.changed_from_previous_ver? }
    end

    event :reject do
      transition :pending_org_approval => :rejected_by_org
      transition :pending_cparty_approval => :rejected_by_cparty
    end

    event :cancel do
      transition :active => :canceled
    end

  end

  def changed_from_previous_ver?
    AgrVersionDiffService.new(self, self.previous_version).different? || self.rules_changed_from_prev_ver?
  end

  def finalize_activation
    create_account_for_org unless org_account_exists?
    create_account_for_cparty unless cparty_account_exists?
  end


  private

  def create_account_for_org
    Account.create!(organization: organization, accountable: counterparty) if organization.subcontrax_member?
  end

  def create_account_for_cparty
    Account.create!(organization: counterparty, accountable: organization) if counterparty.subcontrax_member?
  end

  def org_account_exists?
    Account.where("organization_id = ? and accountable_id = ? and accountable_type = 'Organization'",
                  organization_id, counterparty_id).present?
  end

  def cparty_account_exists?
    Account.where("organization_id = ? and accountable_id = ? and accountable_type = 'Organization'",
                  counterparty_id, organization_id).present?
  end


  def end_date_validation
    if self.ends_at && (subcon_tickets.size > 0 || prov_tickets.size > 0) && Ticket.created_after(self.organization, self.counterparty, self.ends_at).size > 0
      errors.add :ends_at, I18n.t('activerecord.errors.agreement.ends_at_invalid', date: ends_at.strftime('%b, %d, %Y'))
    end
  end

  def ensure_state_before_change
    errors.add :status, I18n.t('activerecord.errors.agreement.change_when_active') if agreement_locked?
  end

  def agreement_locked?
    res = false
    if self.status_changed?
      res = true if changed_other_than?(%w(status ends_at)) && self.status_was == OrganizationAgreement::STATUS_ACTIVE
      res = true if changed_other_than?(%w(status)) && self.status_was == OrganizationAgreement::STATUS_CANCELED
    else
      res = true if (self.active? && changed_other_than?(%w(ends_at))) || self.canceled? || self.replaced?
    end
    res
  end

  # determines if attributes other than the ones specified have been changed
  # @param attributes an array of strings with attributes to exclude from the check
  def changed_other_than?(attributes = [])
    test_hash = self.changed_attributes.clone
    attributes.each do |attr|
      test_hash.delete(attr)
    end
    test_hash.size > 0
  end


end
