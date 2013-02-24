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

class OrganizationAgreement < Agreement

  # first we will define the organization state values
  STATUS_PENDING_ORG_APPROVAL    = 11000
  STATUS_PENDING_CPARTY_APPROVAL = 11001
  STATUS_REJECTED_BY_ORG         = 11002
  STATUS_REJECTED_BY_CPARTY      = 11003

  validate :ensure_state_before_change
  validate :end_date_validation#, if: ->(agr) { agr.ends_at_changed? }

  # The state machine definitions
  state_machine :status, :initial => :draft do
    state :draft, value: STATUS_DRAFT
    state :active, value: STATUS_ACTIVE
    state :pending_org_approval, value: STATUS_PENDING_ORG_APPROVAL do
      validates_presence_of :change_reason
      validates_presence_of :posting_rules
    end
    state :pending_cparty_approval, value: STATUS_PENDING_CPARTY_APPROVAL do
      validates_presence_of :change_reason
      validates_presence_of :posting_rules
    end
    state :rejected_by_org, value: STATUS_REJECTED_BY_ORG do
      validates_presence_of :change_reason
      validates_presence_of :posting_rules
    end
    state :rejected_by_cparty, value: STATUS_REJECTED_BY_CPARTY do
      validates_presence_of :change_reason
      validates_presence_of :posting_rules
    end
    state :canceled, value: STATUS_CANCELED do
      validates_presence_of :change_reason
    end
    state :replaced, value: STATUS_REPLACED

    # create the accounts after activating the agreement
    after_transition any => :active do |agreement, transition|
      unless Account.where("organization_id = ? and accountable_id = ? and accountable_type = 'Organization'", agreement.organization_id, agreement.counterparty_id).present?
        Account.create!(organization: agreement.organization, accountable: agreement.counterparty) if agreement.organization.subcontrax_member?
      end
      unless Account.where("organization_id = ? and accountable_id = ? and accountable_type = 'Organization'", agreement.counterparty_id, agreement.organization_id).present?
        Account.create!(organization: agreement.counterparty, accountable: agreement.organization) if agreement.counterparty.subcontrax_member?
      end
    end


    event :submit_for_approval do
      transition :draft => :pending_cparty_approval, if: ->(agreement) { agreement.creator.organization == agreement.organization && agreement.counterparty.subcontrax_member? }
      transition :draft => :pending_org_approval, if: ->(agreement) { agreement.creator.organization == agreement.counterparty && agreement.organization.subcontrax_member? }
    end

    event :activate do
      transition :draft => :approved_pending, if: ->(agreement) { Agreement.sibling_active_agreements(agreement).size > 0 }
      transition :draft => :active, if: ->(agreement) { !agreement.organization.subcontrax_member? }
      transition :draft => :active, if: ->(agreement) { !agreement.counterparty.subcontrax_member? }
    end

    event :submit_change do
      transition [:pending_org_approval, :rejected_by_cparty] => :pending_cparty_approval
      transition [:pending_cparty_approval, :rejected_by_org] => :pending_org_approval
    end

    event :accept do
      transition [:pending_org_approval, :pending_cparty_approval] => :approved_pending, if: ->(agreement) { Agreement.sibling_active_agreements(agreement).size > 0 }
      transition [:pending_org_approval, :pending_cparty_approval] => :active, if: ->(agreement) { Agreement.sibling_active_agreements(agreement).size == 0 }

    end

    event :reject do
      transition :pending_org_approval => :rejected_by_org
      transition :pending_cparty_approval => :rejected_by_cparty
    end

    event :cancel do
      transition :active => :canceled
    end

  end

  private
  def end_date_validation
    errors.add :ends_at, I18n.t('activerecord.errors.agreement.ends_at_invalid', date: ends_at.strftime('%b, %d, %Y')) if Ticket.created_after(self.organization_id, self.counterparty_id, self.ends_at).size > 0
  end

  def ensure_state_before_change
    errors.add :status, I18n.t('activerecord.errors.agreement.change_when_active') if agreement_locked?
  end

  def agreement_locked?
    res = false
    if self.status_changed?
      res = true if changed_other_than?(%w('status', 'ends_at')) && self.status_was == OrganizationAgreement::STATUS_ACTIVE
      res = true if changed_other_than?(%w('status')) && self.status_was == OrganizationAgreement::STATUS_CANCELED
    else
      res = true if (self.active? && changed_other_than?(%w(ends_at))) || self.canceled? || self.replaced?
    end
    res
  end

  # determines if attributes other than the ones specified have been changed
  # @param attributes an array of strings with attributes to exclude from the check
  def changed_other_than?(attributes = [])
    test_hash = self.changed_attributes
    attributes.each do |attr|
      test_hash.delete(attr)
    end
    test_hash.size > 0
  end

end
