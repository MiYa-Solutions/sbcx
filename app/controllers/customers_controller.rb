class CustomersController < ApplicationController
  def new

    @customer = Customer.new

  end

  def create
    @organization = current_user.organization
    @customer = @organization.customers.build(params[:customer])

    # todo create symbols for the notification strings
    if @customer.save
      flash[:success] = "Customer created!"
      redirect_to  customer_path @customer
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
    @customers = current_user.organization.customers.paginate(page: params[:page], per_page: 10)
  end

  def show
    @customer = current_user.organization.customers.find(params[:id])
  end
end
