class OrganizationAgreement < Agreement

  # first we will define the organization state values
  STATUS_PENDING_ORG_APPROVAL    = 1
  STATUS_PENDING_CPARTY_APPROVAL = 2
  STATUS_REJECTED_BY_ORG         = 3
  STATUS_REJECTED_BY_CPARTY      = 4
  STATUS_ACTIVE                  = 5
  STATUS_CANCELED                = 6
  STATUS_REPLACED                = 7


  # The state machine definitions
  state_machine :status, :initial => :draft do
    state :draft, value: STATUS_DRAFT
    state :active, value: STATUS_ACTIVE
    state :pending_org_approval, value: STATUS_PENDING_ORG_APPROVAL do
      validates_presence_of :change_reason
    end
    state :pending_cparty_approval, value: STATUS_PENDING_CPARTY_APPROVAL do
      validates_presence_of :change_reason
    end
    state :rejected_by_org, value: STATUS_REJECTED_BY_ORG do
      validates_presence_of :change_reason
    end
    state :rejected_by_cparty, value: STATUS_REJECTED_BY_CPARTY do
      validates_presence_of :change_reason
    end
    state :canceled, value: STATUS_CANCELED do
      validates_presence_of :change_reason
    end
    state :replaced, value: STATUS_REPLACED


    event :submit_for_approval do
      transition :draft => :pending_cparty_approval, if: ->(agreement) { agreement.creator.organization == agreement.organization && agreement.counterparty.subcontrax_member? }
      transition :draft => :pending_org_approval, if: ->(agreement) { agreement.creator.organization == agreement.counterparty && agreement.organization.subcontrax_member? }
    end

    event :activate do
      transition :draft => :active, if: ->(agreement) { !agreement.organization.subcontrax_member? }
      transition :draft => :active, if: ->(agreement) { !agreement.counterparty.subcontrax_member? }
    end

    event :submit_change do
      transition [:pending_org_approval, :rejected_by_cparty] => :pending_cparty_approval
      transition [:pending_cparty_approval, :rejected_by_org] => :pending_org_approval
    end

    event :accept do
      transition [:pending_org_approval, :pending_cparty_approval] => :active
    end

    event :reject do
      transition :pending_org_approval => :rejected_by_org
      transition :pending_cparty_approval => :rejected_by_cparty
    end

    event :cancel do
      transition :active => :canceled
    end

  end

end