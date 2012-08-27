class CustomersController < ApplicationController
  before_filter :authenticate_user!
  filter_resource_access

  def new

    @customer = Customer.new

  end

  def create
    @organization = current_user.organization
    @customer     = @organization.customers.build(params[:customer])

    # todo create symbols for the notification strings
    if @customer.save
      respond_to do |format|
        format.js { }
        format.html do
          flash[:success] = "Customer created!"
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
    @customer = current_user.organization.customers.find(params[:id])
    if @customer.update_attributes(params[:customer])
      flash[:success] = "Profile updated"
      redirect_to @customer
    else
      render 'edit'
    end

  end

  def index

    if params[:search].nil?
      @customers = current_user.organization.customers.paginate(page: params[:page], per_page: 10)
    else
      @customers = Customer.search(params[:search], current_user.organization.id).paginate(page: params[:page], per_page: 10)
    end

    #@new_customers = current_user.organization.customers.paginate(page: params[:page], per_page: 2)
    #@customers = current_user.organization.customer_candidates(params[:search])
  end

  def show
    @customer = current_user.organization.customers.find(params[:id])
  end
end
