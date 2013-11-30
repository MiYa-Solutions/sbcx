authorization do

  role :guest do
    has_permission_on :authorization_rules, :to => :read
  end
  role :admin do
    has_permission_on [:affiliates, :organizations, :users, :providers, :subcontractors, :service_calls, :customers],
                      :to => [:index, :show, :new, :create, :edit, :update, :destroy, :read]

  end

  role :technician do

    has_permission_on :static_pages, to: [:index, :read]
    has_permission_on :appointments, :to => [:index, :show, :new, :create, :edit, :update, :destroy, :read]
    has_permission_on :notifications, to: [:index, :show, :read, :update, :destroy] do
      if_attribute :user_id => is { user.id }
    end
    has_permission_on :boms, to: [:new, :create, :index, :show, :read, :update, :destroy, :edit] do
      if_attribute :ticket => { :organization => is { user.organization } }
    end
    has_permission_on :materials, to: [:new, :index]
    has_permission_on :materials, to: [:create, :show, :read, :update, :edit] do
      if_attribute :organization_id => is { user.organization_id }
    end

    has_permission_on :my_users, to: [:index, :read]
    has_permission_on :providers, :to => :index
    has_permission_on :subcontractors, :to => :index
    has_permission_on :affiliates, :to => :index
    has_permission_on :service_calls, :to => :index
    has_permission_on :service_calls, :to => [:show, :edit, :update] do
      if_attribute :organization_id => is { user.organization_id }
    end

  end

  role :dispatcher do

    includes :technician
    has_permission_on :authorization_rules, :to => :read
    has_permission_on :customers, :to => [:new, :create]
    has_permission_on :customers, :to => [:index, :show, :edit, :update] do
      if_attribute :organization => is { user.organization }
      if_attribute :organization => { :subcontrax_member => is_not { true } }, :organization_id => is_in { user.organization.providers.pluck('organizations.id') }
    end
    has_permission_on :service_calls, :to => [:new, :create] do
    end

  end
  role :org_admin do
    includes :dispatcher

    has_permission_on :invites, to: [:new, :show, :index] do
      if_attribute organization_id: is { user.organization_id }
      if_attribute affiliate_id: is { user.organization_id }
    end

    has_permission_on :invites, to: [:edit, :update] do
      if_attribute affiliate_id: is { user.organization_id }
    end

    has_permission_on :invites, to: [:create] do
      if_attribute organization_id: is { user.organization_id }
    end


    has_permission_on :materials, to: [:destroy] do
      if_attribute :organization_id => is { user.organization_id }
    end

    has_permission_on :my_users, :to => [:new, :create, :edit, :update, :show]
    has_permission_on :subcontractors, :to => [:new, :create]
    has_permission_on :providers, :to => [:new, :create]
    has_permission_on :affiliates, :to => [:new, :create]
    has_permission_on :accounting_entries, :to => [:new, :create, :show, :index]


    has_permission_on :organizations, to: [:show, :edit, :update] do
      if_attribute :id => is { user.organization.id }
    end

    has_permission_on :providers, to: :show do
      if_attribute :subcontrax_member => true
      if_attribute :id => is_in { user.organization.provider_ids }
    end

    has_permission_on :providers, to: [:edit, :update] do
      if_attribute :id => is_in { user.organization.provider_ids }, :subcontrax_member => is_not { true }
    end
    has_permission_on :subcontractors, to: [:show] do
      if_attribute :subcontrax_member => true
      if_attribute :id => is_in { user.organization.subcontractor_ids }
    end

    has_permission_on :subcontractors, to: [:edit, :update] do
      if_attribute :id => is_in { user.organization.subcontractor_ids }, :subcontrax_member => is_not { true }
    end
    has_permission_on :affiliates, to: :show do
      if_attribute :subcontrax_member => true
      if_attribute :id => is_in { user.organization.affiliate_ids }
      if_attribute :id => is_in { user.organization.provider_ids }
      if_attribute :id => is_in { user.organization.subcontractor_ids }
    end

    has_permission_on :affiliates, to: [:edit, :update] do
      if_attribute :id => is_in { user.organization.affiliate_ids }, :subcontrax_member => is_not { true }
    end

    has_permission_on :users, :to => [:index, :show, :new, :create, :edit, :update]
    #has_permission_on :customers, :to => [:index, :show, :new, :create, :edit, :update]

    has_permission_on :agreements, :to => [:new]

    has_permission_on :agreements, :to => [:show] do
      # when status is not draft, any user of either orgs can see the agreement
      if_attribute :organization_id => is { user.organization.id }, :status => is_not { OrganizationAgreement::STATUS_DRAFT }
      if_attribute :counterparty_id => is { user.organization.id }, :status => is_not { OrganizationAgreement::STATUS_DRAFT }

      # when status is draft
      if_attribute :organization_id => is { user.organization.id }, :status => is { OrganizationAgreement::STATUS_DRAFT }, :organization_id => is { user.organization_id }, :creator_id => is_in { user.organization.user_ids }
      if_attribute :counterparty_id => is { user.organization.id }, :status => is { OrganizationAgreement::STATUS_DRAFT }, :counterparty_id => is { user.organization_id }, :creator_id => is_in { user.organization.user_ids }

      # customer agreements
      if_attribute type: 'CustomerAgreement', :organization_id => is { user.organization.id }
    end
    has_permission_on :agreements, :to => [:create] do
      if_attribute :organization_id => is { user.organization.id }
      if_attribute :counterparty_id => is { user.organization.id }
    end

    # todo define proper permission for creating agreements so one can't create an agreement with a local organization of another member

    has_permission_on :agreements, :to => [:edit, :update] do

      # when status is active allow users from either party to update the agreement
      if_attribute :type => is_in { ['SubcontractingAgreement', 'OrganizationAgreement'] }, :status => is { OrganizationAgreement::STATUS_ACTIVE }, :counterparty_id => is { user.organization_id }
      if_attribute :type => is_in { ['SubcontractingAgreement', 'OrganizationAgreement'] }, :status => is { OrganizationAgreement::STATUS_ACTIVE }, :organization_id => is { user.organization_id }

      # when the agreement status is draft
      if_attribute :type => is_in { ['SubcontractingAgreement', 'OrganizationAgreement'] }, :status => is { OrganizationAgreement::STATUS_DRAFT }, :organization_id => is { user.organization_id }, :creator_id => is_in { user.organization.user_ids }
      if_attribute :type => is_in { ['SubcontractingAgreement', 'OrganizationAgreement'] }, :status => is { OrganizationAgreement::STATUS_DRAFT }, :counterparty_id => is { user.organization_id }, :creator_id => is_in { user.organization.user_ids }

      # when the status is not active nor draft allow only the party that needs to respond to the other's update
      if_attribute :type => is_in { ['SubcontractingAgreement', 'OrganizationAgreement'] }, :counterparty_id => is { user.organization_id }, :status => is_not_in { [OrganizationAgreement::STATUS_ACTIVE, OrganizationAgreement::STATUS_DRAFT] }, :updater => { :organization_id => is_not { user.organization.id } }
      if_attribute :type => is_in { ['SubcontractingAgreement', 'OrganizationAgreement'] }, :organization_id => is { user.organization_id }, :status => is_not_in { [OrganizationAgreement::STATUS_ACTIVE, OrganizationAgreement::STATUS_DRAFT] }, :updater => { :organization_id => is_not { user.organization.id } }

      # when customer agreement ensure the user org is the organization of the agreement
      if_attribute :type => is { 'CustomerAgreement' }, organization_id: is { user.organization_id }
    end

    # todo define proper permissions
    has_permission_on :posting_rules, to: [:new, :edit, :show, :index]
    has_permission_on :posting_rules, to: [:update, :create, :destroy] do
      if_attribute :agreement => { status: is_not { Agreement::STATUS_ACTIVE } }
    end

    has_permission_on :payments, to: [:new, :create, :update, :edit, :show, :index, :destroy]
  end


end