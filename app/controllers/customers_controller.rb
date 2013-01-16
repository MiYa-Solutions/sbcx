class CustomersController < ApplicationController
  before_filter :authenticate_user!
  filter_resource_access

  def new

    #@customer = Customer.new

  end

  def create
    if params[:customer][:organization_id].nil?
      @organization = current_user.organization
    else
      @organization = Organization.find(params[:customer][:organization_id])
    end

    @customer = @organization.customers.build(permitted_params(nil).customer)


    # todo create symbols for the notification strings
    if @customer.save
      respond_to do |format|
        format.js { }
        format.html do
          flash[:success] = t 'customer.crud_messages.success', customer_name: @customer.name
          redirect_to customer_path @customer
        end
      end
    else
      render 'new'
    end
  end

  def edit
    @customer = current_user.organization.customers.find(params[:id])
  end

  def update
    #@customer = current_user.organization.customers.find(params[:id])

    respond_to do |format|
      format.js { }
      format.any(:html, :mobile) do
        if @customer.update_attributes(permitted_params(nil).customer)
          flash[:success] = "Profile updated"
          redirect_to customer_path @customer
        else
          render 'edit'
        end
      end
    end

  end

  def index

    respond_to do |format|
      format.js do
        if params[:organization_id].nil? || params[:organization_id].empty?
          if params[:search].nil?
            @customers = Customer.fellow_customers(current_user.organization.id)

          else
            @customers = Customer.search(params[:search], current_user.organization.id)
          end
          render 'customers/index'
        else
          unless  Organization.find(params[:organization_id]).subcontrax_member? && !Organization.find(params[:organization_id]) == current_user.organization
            if params[:search].nil?
              @customers = Customer.fellow_customers(params[:organization_id])
            else
              @customers = Customer.search(params[:search], params[:organization_id])
            end
            render 'customers/customer_select'
          end
        end


      end
      format.any(:html, :mobile) do
        if params[:organization_id].nil? || params[:organization_id].empty?
          if params[:search].nil?
            @customers = Customer.fellow_customers(current_user.organization.id).paginate(page: params[:page], per_page: 10)
          else
            @customers = Customer.search(params[:search], current_user.organization.id).paginate(page: params[:page], per_page: 10)
          end
        else
          unless  Organization.find(params[:organization_id]).subcontrax_member? && !Organization.find(params[:organization_id]) == current_user.organization
            if params[:search].nil?
              @customers = Customer.fellow_customers(params[:organization_id]).paginate(page: params[:page], per_page: 10)
            else
              @customers = Customer.search(params[:search], params[:organization_id]).paginate(page: params[:page], per_page: 10)
            end
          end


        end

      end


    end


  end

  def show
    if permitted_to! :show, Customer.find(params[:id])
      @customer = Customer.find(params[:id])
    end

  end

  def new_customer_from_params
    @customer ||= current_user.organization.customers.new(permitted_params(nil).customer)
  end


end
