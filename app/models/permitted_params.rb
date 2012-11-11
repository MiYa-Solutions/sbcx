class PermittedParams < Struct.new(:params, :user, :obj)
  def service_call
    if params[:service_call].nil?
      params.permit
    else
      params[:service_call].permit(*service_call_attributes)
    end

  end

  def service_call_attributes
    case obj.class
      when MyServiceCall
        if user.roles.pluck(:name).include? Role::ORG_ADMIN_ROLE_NAME
          [:status_event,
           :provider_id,
           :subcontractor_id,
           :customer_id,
           :technician_id,
           :started_on_text,
           :completed_on_text,
           :new_customer,
           :address1,
           :address2,
           :company,
           :city,
           :state,
           :zip,
           :country,
           :phone,
           :mobile_phone,
           :work_phone,
           :email,
           :notes,
           :total_price
          ]
        end
      when TransferredServiceCall
        if user.roles.pluck(:name).include? Role::ORG_ADMIN_ROLE_NAME
          [:status_event,
           :provider_id,
           :subcontractor_id,
           :customer_id,
           :technician_id,
           :started_on_text,
           :completed_on_text,
           :new_customer,
           :address1,
           :address2,
           :company,
           :city,
           :state,
           :zip,
           :country,
           :phone,
           :mobile_phone,
           :work_phone,
           :email,
           :notes]
        end

      else
        if user.roles.pluck(:name).include? Role::ORG_ADMIN_ROLE_NAME
          [:status_event,
           :provider_id,
           :subcontractor_id,
           :customer_id,
           :technician_id,
           :started_on_text,
           :completed_on_text,
           :new_customer,
           #:address1,
           #:address2,
           :company,
           :city,
           :state,
           :zip,
           :country,
           :phone,
           :mobile_phone,
           :work_phone,
           :email,
           :notes
          ]
        end
    end
  end

  def customer
    params.require(:customer).permit(*customer_attributes)

  end

  def customer_attributes
    [:address1,
     :address2,
     :city,
     :company,
     :country,
     :email,
     :mobile_phone,
     :name,
     :phone,
     :state,
     :work_phone,
     :zip
    ]
  end

  def organization
    if params[:organization].nil?
      # need this step to work around a declarative authorization problem with strong parameters
      params.permit
    else
      params.require(:organization).permit(*organization_attributes)
    end

  end

  def organization_attributes
    [:address1,
     :address2,
     :city,
     :company,
     :country,
     :email,
     :mobile,
     :name,
     :phone,
     :state,
     :status_event,
     :website,
     :work_phone,
     :zip,
     :organization_role_ids,
     :provider_id,
     :users_attributes,
     :provider_attributes,
     :agreement_attributes,
     :agreements
    ]
  end

  def provider
    if params[:provider].nil?
      # need this step to work around a declarative authorization problem with strong parameters
      params.permit
    else
      params.require(:provider).permit(*organization_attributes)
    end

  end

  def subcontractor
    if params[:subcontractor].nil?
      # need this step to work around a declarative authorization problem with strong parameters
      params.permit
    else
      params.require(:subcontractor).permit(*organization_attributes)
    end
  end

  def affiliate
    if params[:affiliate].nil?
      params.permit
    else
      params[:affiliate].permit(*organization_attributes)
    end
  end

  def my_user
    if params[:user].nil?
      params.permit
    else
      params[:user].permit(*my_user_attributes)
    end


  end

  def my_user_attributes
    [:email, :password,
     :password_confirmation,
     :remember_me,
     :organization_attributes,
     :organization,
     :role_ids,
     :first_name,
     :last_name,
     :phone,
     :company,
     :address1,
     :address2,
     :country,
     :state,
     :city,
     :zip,
     :mobile_phone,
     :work_phone]

  end

  def new_user_attributes
    [:email, :password,
     :password_confirmation,
     :remember_me,
     :organization_attributes,
     :organization,
     :role_ids,
     :first_name,
     :last_name,
     :phone,
     :company,
     :address1,
     :address2,
     :country,
     :state,
     :city,
     :zip,
     :mobile_phone,
     :work_phone].tap do |attributes|
      attributes << { organization_attributes: organization_attributes }
    end

  end

end