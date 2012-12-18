authorization do

  role :guest do
    has_permission_on :static_pages, to: :index
  end
  role :admin do
    has_permission_on [:affiliates, :static_pages, :organizations, :users, :providers, :subcontractors, :service_calls, :customers],
                      :to => [:index, :show, :new, :create, :edit, :update, :destroy, :read]

  end

  role :technician do

    has_permission_on :static_pages, to: [:index, :read]
    has_permission_on :notifications, to: [:index, :show, :read, :update, :destroy] do
      if_attribute :user => is { user }
    end
    has_permission_on :boms, to: [:new, :create, :index, :show, :read, :update, :destroy, :edit] do
      if_attribute :ticket => { :organization => is { user.organization } }
    end
    has_permission_on :materials, to: [:new, :create, :index, :show, :read, :update, :edit]
    has_permission_on :my_users, to: [:index, :read]
    has_permission_on [:providers, :subcontractors], :to => [:index]
    has_permission_on [:affiliates, :subcontractors], :to => [:index]
    has_permission_on :service_calls, :to => [:index, :show, :edit, :update]

  end

  role :dispatcher do

    includes :technician
    has_permission_on :customers, :to => [:new, :create]
    has_permission_on :customers, :to => [:index, :show, :edit, :update] do
      if_attribute :organization => is { user.organization }
      if_attribute :organization => { :subcontrax_member => is_not { true } }, :organization_id => is_in { user.organization.providers.pluck('organizations.id') }
    end
    has_permission_on :service_calls, :to => [:new, :create] do
    end
    has_permission_on :service_calls, :to => [:edit, :index, :show, :update] do
      if_attribute :organization_id => is { user.organization.id }
    end

  end
  role :org_admin do
    includes :dispatcher
    has_permission_on :my_users, :to => [:new, :create, :edit, :update, :show]
    has_permission_on [:providers, :subcontractors], :to => [:new, :create]
    has_permission_on [:affiliates], :to => [:new, :create]


    has_permission_on :organizations, to: [:show, :edit, :update] do
      if_attribute :id => is { user.organization.id }
    end

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
    has_permission_on :affiliates, to: [:show] do
      if_attribute :subcontrax_member => true
      if_attribute :provider_ids => contains { user.organization.id }
      if_attribute :subcontractor_ids => contains { user.organization.id }
    end

    has_permission_on :affiliates, to: [:edit, :update] do
      if_attribute :provider_ids => contains { user.organization.id }
      if_attribute :subcontractor_ids => contains { user.organization.id }
    end

    has_permission_on :users, :to => [:index, :show, :new, :create, :edit, :update]
    #has_permission_on :customers, :to => [:index, :show, :new, :create, :edit, :update]

    has_permission_on :agreements, :to => [:index, :show, :new, :edit]

    has_permission_on :agreements, :to => [:create]

    has_permission_on :agreements, :to => [:update] do
      if_attribute :provider_id => is { user.organization.id }
      if_attribute :subcontractor_id => is { user.organization.id }
    end
  end


end