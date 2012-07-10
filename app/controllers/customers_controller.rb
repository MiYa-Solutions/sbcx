class CustomersController < ApplicationController
  def new
    @organization = Organization.find(params[:organization_id])
    @customer = Customer.new
    render 'new'
  end

  def create
    @organization = Organization.find(params[:organization_id])
    @customer = @organization.customers.build(params[:customer])

    # todo create symbols for the notification strings
    if @customer.save
      flash[:success] = "Customer created!"
      redirect_to  organization_customer_path @organization, @customer
    else
      render 'new'
    end
  end

  def edit
  end
  def update
  end

  def index
    @customers = Organization.find(params[:organization_id]).customers.paginate(page: params[:page], per_page: 10)
  end

  def show
    @customer = Customer.find(params[:id])
  end
end
