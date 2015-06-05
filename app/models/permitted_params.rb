class PermittedParams < Struct.new(:params, :user, :obj)

  def permitted_attribute?(resource, attribute, attribute_val = nil)

    unless attribute_val.nil?
      old_val                  = params[attribute]
      self[:params][attribute] = attribute_val
    end

    method_sym               = "#{resource}_attributes".to_sym
    res                      = send(method_sym).include?(attribute)
    self[:params][attribute] = old_val unless attribute_val.nil?
    res
  end

  def admin_user
    params.permit!
  end

  def posting_rule
    if params[:posting_rule].nil?
      params.permit
    else
      params.require(:posting_rule).permit(*posting_rule_attributes)
    end

  end

  def posting_rule_attributes
    [
        :agreement_id, :rate,
        :rate_type, :sunday,
        :sunday_from, :sunday_to,
        :cash_rate, :cash_rate_type,
        :cheque_rate, :cheque_rate_type,
        :credit_rate, :credit_rate_type,
        :amex_rate, :amex_rate_type
    ]

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
    [:material_name, :material_id, :cost, :price, :quantity, :buyer_type, :buyer_id, :description]

  end

  def service_call
    params[:service_call] = params[:my_service_call] if params[:my_service_call].present?
    params[:service_call] = params[:subcon_service_call] if params[:subcon_service_call].present?
    params[:service_call] = params[:broker_service_call] if params[:broker_service_call].present?
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
    attrs = basic_service_call_attr |
        sc_work_status_attr |
        sc_billing_status_attrs |
        sc_collection_attrs |
        sc_financial_attrs |
        sc_subcon_status_attrs |
        sc_provider_status_attrs

    attrs.concat sc_transfer_attrs if sc_transfer_attrs.size > 0
    attrs.concat [:customer_id, :customer_name] if obj.nil? || obj.new?
    attrs
  end


  alias_method :my_service_call_attributes, :service_call_attributes
  alias_method :broker_service_call_attributes, :service_call_attributes
  alias_method :subcon_service_call_attributes, :service_call_attributes

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
     :zip,
     :status_event,
     :notes,
     :default_tax
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
    [:industry, :other_industry,
     :address1,
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
     { :organization_role_ids => [] },
     :provider_id,
     :users_attributes,
     :provider_attributes,
     :agreement_attributes,
     :agreements, :default_tax
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
      params[:agreement].permit(*agreement_attributes)
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
     :work_phone, :time_zone, :current_password, { :role_ids => [] },]

  end

  def agreement_attributes
    attr = []
    if obj.nil?
      attr = [:name, :description, :organization_id, :counterparty_id, :counterparty_type]
    else
      attr = [:status_event, :change_reason, :name, :description, :starts_at, :ends_at_text, :payment_terms]
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

  def appointment
    if params[:appointment].nil?
      # need this step to work around a declarative authorization problem with strong parameters
      params.permit
    else
      params.require(:appointment).permit(*appointment_attributes)
      #params.require(:provider).permit!
    end

  end

  def appointment_attributes
    [
        :title,
        :description,
        :starts_at,
        :starts_at_date_text,
        :starts_at_time_text,
        :ends_at,
        :ends_at_date_text,
        :ends_at_time_text,
        :appointable_id,
        :appointable_type,
        :recurring,
        :all_day
    ]
  end

  private

  def billing_allowed?

    res = false

    if (obj.present? && obj.allow_collection?) || (obj.present? && obj.instance_of?(MyServiceCall))
      if params[:service_call]
        res = billing_event_allowed? params[:service_call]
      else
        res = billing_event_allowed? params
      end
    end

    res
  end

  def billing_event_allowed?(params_to_check)
    res = true

    res = false if params_to_check[:billing_status_event] == 'deposited'
    res = false if params_to_check[:billing_status_event] == 'clear'
    res = false if params_to_check[:billing_status_event] == 'reject'
    res = false if params_to_check[:billing_status_event] == 'cancel'
    res = false if params_to_check[:billing_status_event] == 'reopen'

    res
  end

  def subcontractor_status_allowed?
    params_to_check = params[:service_call] ? params[:service_call] : params
    res             = false

    if obj.present? && obj.subcontractor.present? && obj.subcon_settlement_allowed?
      res = subcon_event_allowed? params_to_check
    end
    res
  end

  def subcon_event_allowed?(params_to_check)
    res = false

    res = true if params_to_check[:subcontractor_status_event] == 'settle'
    res = true if params_to_check[:subcontractor_status_event].nil?

    res
  end

  def provider_status_allowed?
    params_to_check = params[:service_call] ? params[:service_call] : params
    res             = false

    if obj && obj.kind_of?(TransferredServiceCall) && obj.provider_settlement_allowed?
      res = provider_event_allowed? params_to_check
    end

    res
  end

  def provider_event_allowed?(params_to_check)
    res = false
    res = true if params_to_check[:provider_status_event] == 'settle'
    res = true if params_to_check[:provider_status_event].nil?
    res
  end

  def basic_service_call_attr

    basic_attr = [:started_on_text,
                  :started_on,
                  :completed_on_text,
                  :scheduled_for_text,
                  :scheduled_for,
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
                  :collector_id,
                  :name,
                  :collector_type,
                  :external_ref, :project_id, :project_name]

    basic_attr = basic_attr | sc_technician_attr if user.roles.map(&:name).include? Role::TECHNICIAN_ROLE_NAME
    basic_attr = basic_attr | sc_dispatcher_attr if user.roles.map(&:name).include? Role::DISPATCHER_ROLE_NAME

    basic_attr = basic_attr | sc_org_attr if user.roles.map(&:name).include? Role::ORG_ADMIN_ROLE_NAME

    basic_attr
  end

  def sc_technician_attr
    attr = []
    attr << :status_event if sc_status_event_permitted?
    attr | [:tag_list, :payment_type]
  end

  def sc_dispatcher_attr
    sc_technician_attr | [:provider_id,
                          :provider_agreement_id,
                          :subcon_agreement_id,
                          :subcontractor_id,
                          :technician_id,
                          :transferable,
                          :re_transfer,
                          :new_customer]
  end

  def sc_org_attr
    sc_dispatcher_attr
  end

  def sc_status_event_permitted?
    params_to_check = params[:status_event] ? params : params[:service_call]
    res             = true
    if params_to_check
      res = false if params_to_check[:status_event] == 'cancel' && obj.provider.member? && obj.new? && obj.kind_of?(TransferredServiceCall)
      res = false if params_to_check[:status_event] == 'provider_canceled'
    end
    res
  end

  def sc_work_status_attr
    attr = []
    attr << :work_status_event if sc_work_event_permitted?
    attr
  end

  def sc_work_event_permitted?
    params_to_check = params[:service_call] ? params[:service_call] : params
    res             = true

    res             = false if obj && obj.transferred? && obj.subcontractor.subcontrax_member?
    res             = false if params_to_check[:work_status_event] == 'cancel'
    res             = false if params_to_check[:work_status_event] == 'reset'
    res

  end

  def sc_billing_status_attrs
    billing_allowed? ? [:billing_status_event, :collector_id, :collector_type, :payment_type, :payment_amount, :payment_notes] : []
  end

  def sc_collection_attrs
    if user.roles.map(&:name).include?(Role::DISPATCHER_ROLE_NAME) || user.roles.map(&:name).include?(Role::ORG_ADMIN_ROLE_NAME)
      case obj.class.name
        when MyServiceCall.name
          [:allow_collection]
        when TransferredServiceCall.name
          obj.present? && !obj.provider.subcontrax_member? ? [:allow_collection] : []
        else
          []
      end
    else
      []
    end
  end

  def sc_financial_attrs
    obj && obj.can_change_financial_data? ? [:tax] : []
  end

  def sc_subcon_status_attrs
    subcontractor_status_allowed? ? [:subcontractor_status_event, :subcon_settle_amount, :subcon_settle_type] : []
  end

  def sc_provider_status_attrs
    provider_status_allowed? ? [:provider_status_event, :prov_settle_type, :prov_settle_amount] : []
  end

  def sc_transfer_attrs
    sc_subcon_transfer_props | sc_provider_transfer_props

  end

  def sc_provider_transfer_props
    agr = nil
    if obj && obj.provider_agreement
      agr = obj.provider_agreement
    else

      agr = Agreement.find(params[:service_call][:provider_agreement_id]) if params[:service_call] && params[:service_call][:provider_agreement_id]
    end

    agr && agr.get_transfer_props.map(&:attribute_names).size > 0 ? [properties: agr.get_transfer_props.map(&:attribute_names).flatten] : []
  end

  def sc_subcon_transfer_props
    agr = nil
    if obj && obj.subcon_agreement
      agr = obj.subcon_agreement
    else

      agr = Agreement.find(params[:service_call][:subcon_agreement_id]) if params[:service_call] && params[:service_call][:subcon_agreement_id]
    end

    agr && agr.get_transfer_props.map(&:attribute_names).size > 0 ? [properties: agr.get_transfer_props.map(&:attribute_names).flatten] : []
  end

end