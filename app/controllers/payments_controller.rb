class PaymentsController < ApplicationController
  filter_resource_access

  def new
    respond_to do |format|
      format.html # new.html.erb
      format.js # new.js.erb
    end
  end

  def create
    respond_to do |format|
      if @payment.save
        format.html { redirect_to agreement_payment_path(@agreement, @payment), notice: 'Payment  was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end

  end

  def edit
  end

  def update
  end

  def show
  end

  def index
  end

  def destroy
  end

  def new_payment_from_params
    @agreement = Agreement.find(params[:agreement_id])
    if params[:payment].nil?
      type     = params[:payment_type]
      @payment = Payment.new_payment(type, @agreement.id)
    else
      type     = params[:payment][:type]
      @payment = Payment.new_payment_from_params(type, permitted_params(nil).payment)
    end
  end
end
