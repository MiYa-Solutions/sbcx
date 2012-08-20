authorization do

  role :guest do
    has_permission_on :static_pages, to: [:read, :index]
  end
  role :admin do
    has_permission_on [:organizations, :users, :providers, :subcontractors, :service_calls],
                      :to => [:index, :show, :new, :create, :edit, :update, :destroy]

  end

  role :technician do
    has_permission_on [:providers, :subcontractors], :to => [:index]
    has_permission_on :service_calls, :to => [:index, :show, :new, :create, :edit, :update]

  end

  role :dispatcher do

    includes :technician
    has_permission_on :service_calls, :to => [:index, :show, :new, :create, :edit, :update] do
      if_attribute :customer_organization_id => is { user.organization.id }
    end

  end
  role :org_admin do
    includes :dispatcher
    has_permission_on [:providers, :subcontractors], :to => [:new, :create]

    has_permission_on :providers, to: [:show] do
      if_attribute :subcontrax_member => true
      if_attribute :subcontractor_ids => contains { user.organization.id }
    end

    has_permission_on :providers, to: [:edit, :update] do
      if_attribute :subcontractor_ids => contains { user.organization.id }
    end
    has_permission_on :subcontractors, to: [:show] do
      if_attribute :subcontrax_member => true
      if_attribute :provider_ids => contains { user.organization.id }
    end

    has_permission_on :subcontractors, to: [:edit, :update] do
      if_attribute :provider_ids => contains { user.organization.id }
    end

    has_permission_on :users, :to => [:index, :show, :new, :create, :edit, :update]
  end


end