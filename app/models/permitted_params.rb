class PermittedParams < Struct.new(:params, :user, :obj)
  def service_call
    params.require(:service_call).permit(*service_call_attributes)
  end

  def service_call_attributes
    case obj.class
      when MyServiceCall
        if user.roles.pluck(:name).include Role::ORG_ADMIN_ROLE_NAME
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
      when TransferredServiceCall
        if user.roles.pluck(:name).include Role::ORG_ADMIN_ROLE_NAME
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
        if user.roles.pluck(:name).include Role::ORG_ADMIN_ROLE_NAME
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
    end

    #  id                   :integer         not null, primary key
    #  customer_id          :integer
    #  notes                :text
    #  started_on           :datetime
    #  organization_id      :integer
    #  completed_on         :datetime
    #  created_at           :datetime        not null
    #  updated_at           :datetime        not null
    #  status               :integer
    #  subcontractor_id     :integer
    #  technician_id        :integer
    #  provider_id          :integer
    #  subcontractor_status :integer
    #  type                 :string(255)
    #  ref_id               :integer
    #  creator_id           :integer
    #  updater_id           :integer
    #  settled_on           :datetime
    #  billing_status       :integer
    #  total_price          :decimal(, )

  end
end