class CustomersController < ApplicationController
  def new
    @customer = Customer.new
  end

  def create
    @organization = Organization.find(params[:id])
    @customer = @organization.customers.build(params[:customer])

    # todo create symbols for the notification strings
    if @customer.save?
      flash[:success] = "Customer created!"
      redirect_to organization_customer_path @customer.id
    end
  end

  def edit
  end
  def update
  end

  def index
  end

  def show
  end
end
