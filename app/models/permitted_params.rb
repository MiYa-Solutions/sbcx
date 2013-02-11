class PermittedParams < Struct.new(:params, :user, :obj)

  def permitted_attribute?(resource, attribute)
    send("#{resource}_attributes").include?(attribute)
  end

  def posting_rule
    if params[:posting_rule].nil?
      params.permit
    else
      params.require(:posting_rule).permit(*posting_rule_attributes)
    end

  end

  def posting_rule_attributes
    [:agreement_id, :rate, :rate_type]
  end

  def payment
    if params[:payment].nil?
      params.permit
    else
      params.require(:payment).permit(*payment_attributes)
    end

  end

  def payment_attributes
    [:agreement_id, :rate, :rate_type]
  end

  def material
    if params[:material].nil?
      params.permit
    else
      params.require(:material).permit(*material_attributes)
    end
  end

  def material_attributes
    [
        :name,
        :description,
        :cost,
        :price,
        :supplier_id
    ]
  end

  def bom
    if params[:bom].nil?
      params.permit
    else
      params[:bom].permit(*bom_attributes)
    end

  end

  def bom_attributes
    [:material_name, :cost, :price, :quantity, :buyer, :buyer_type]

  end

  def service_call
    if params[:service_call].nil?
      params.permit
    else
      # todo figure our a better place to set the default collector to be the user upon the paid event
      if params[:service_call][:billing_status_event] == "paid"
        obj.collector = user
      end
      params[:service_call].permit(*service_call_attributes)
    end

  end

  def service_call_attributes
    permitted_attributes = []
    case obj.class.name
      when MyServiceCall.name
        if user.roles.pluck(:name).include? Role::ORG_ADMIN_ROLE_NAME
          permitted_attributes = [:status_event, :billing_status_event,
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
                                  :total_price, :allow_collection, :re_transfer]
        end

        # if the service call is transferred to a local subcontractor, allow the provider to update the service call with subcontractor events
        permitted_attributes << :subcontractor_status_event unless obj.subcontractor.nil? || obj.subcontractor.subcontrax_member?
        permitted_attributes << :work_status_event unless obj.transferred? && obj.subcontractor.subcontrax_member?
      when TransferredServiceCall.name
        if user.roles.pluck(:name).include? Role::ORG_ADMIN_ROLE_NAME
          permitted_attributes = [:status_event,
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
                                  :notes, :re_transfer]
        elsif user.roles.pluck(:name).include? Role::TECHNICIAN_ROLE_NAME
          permitted_attributes = [:status_event,
                                  :completed_on_text,
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
        elsif user.roles.pluck(:name).include? Role::DISPATCHER_ROLE_NAME
          permitted_attributes = [:status_event,
                                  :subcontractor_id,
                                  :technician_id,
                                  :started_on_text,
                                  :completed_on_text,
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
                                  :notes, :re_transfer]
        end

        permitted_attributes.concat [:billing_status_event, :collector_id] if obj.allow_collection?
        permitted_attributes << :work_status_event if obj.accepted? || (obj.transferred? && !obj.subcontractor.subcontrax_member?)
      else # new service call
        if user.roles.pluck(:name).include? Role::ORG_ADMIN_ROLE_NAME
          permitted_attributes = [:status_event,
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
        elsif user.roles.pluck(:name).include? Role::TECHNICIAN_ROLE_NAME
          [:status_event,
           :completed_on_text,
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
        elsif user.roles.pluck(:name).include? Role::DISPATCHER_ROLE_NAME
          [:status_event,
           :subcontractor_id,
           :technician_id,
           :started_on_text,
           :completed_on_text,
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
    end

    permitted_attributes
  end

  def customer
    if params[:customer].nil?
      params.permit
    else
      params[:customer].permit(*customer_attributes)
    end

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

  def provider_attributes
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
     :provider_id #, agreements_attributes: {"0" => agreement_attributes }]
    ].tap do |attributes|
      attributes << { agreements_attributes: agreement_attributes }

    end
  end

  def provider
    if params[:provider].nil?
      # need this step to work around a declarative authorization problem with strong parameters
      params.permit
    else
      params.require(:provider).permit(*provider_attributes)
      #params.require(:provider).permit!
    end

  end

  def agreement
    if params[:agreement].nil?
      # need this step to work around a declarative authorization problem with strong parameters
      params.permit
    else
      params.require(:agreement).permit(*agreement_attributes)
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

  def agreement_attributes
    attr = []
    if obj.nil?
      attr = [:name, :description, :organization_id, :counterparty_id, :counterparty_type]
    else
      attr = [:status_event, :change_reason, :name, :description]
    end

    attr

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

  def notification
    params.require(:notification).permit(*notification_attributes)
  end

  def notification_attributes
    [:status_event]
  end

  def registration
    if params[:user].nil?
      params.permit
    else
      params[:user].permit(*registration_attributes)
    end
  end

  def registration_attributes
    my_user_attributes.tap do |attributes|
      attributes << { organization_attributes: organization_attributes }
    end


  end

  def subcontracting_agreement
    if params[:agreement].nil?
      params.permit
    else
      params[:agreement].permit(*agreement_attributes)
    end
  end

end