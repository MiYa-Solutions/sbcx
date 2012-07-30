authorization do
  role :admin do
    has_permission_on [:organizations, :users, :providers, :subcontractors, :service_calls],
                      :to => [:index, :show, :new, :create, :edit, :update, :destroy]

  end

  role :technician do
    has_permission_on [:providers, :subcontractors], :to => [:index, :show]
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
    has_permission_on [:providers, :subcontractors], :to => [:index, :show]

    has_permission_on :users, :to => [:index, :show, :new, :create, :edit, :update]
  end


end