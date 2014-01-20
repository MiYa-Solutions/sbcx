class AffiliatesController < ApplicationController
  before_filter :authenticate_user!

  filter_resource_access

  def new
    # no need for the below as declarative_authorization filter_resource_access takes care of it
    #@affiliate = @affiliate.becomes(Affiliate)
  end

  def create

    if @affiliate.save
      redirect_to @affiliate.becomes(Affiliate), :notice => t('affiliates.flash.create_affiliate_success', name: @affiliate.name)
    else
      render :new

    end

  end

  def edit
    # no need for the below as declarative_authorization filter_resource_access takes care of it
    #@affiliate = Affiliate.find(params[:id])
  end

  def update
    # no need for the below as declarative_authorization filter_resource_access takes care of it
    #@affiliate = Affiliate.find(params[:id])
    if @affiliate.update_attributes(permitted_params(@affiliate).affiliate)
      redirect_to @affiliate, flash: { success: t('affiliate.flash_messages.updated_successfully', name: @affiliate.name) }
    else
      render :action => :edit
    end
  end

  def index
    if params[:search].nil?
      @affiliates = Affiliate.the_affiliates(current_user.organization).paginate(page: params[:page], per_page: 10)
    else
      @affiliates = Affiliate.affiliate_search(current_user.organization.id, params[:search]).paginate(page: params[:page], per_page: 10)
    end
  end


  def show
    # no need for the below as declarative_authorization filter_resource_access takes care of it
    #@affiliate = Affiliate.find(params[:id])
    @agreements = Agreement.our_agreements(current_user.organization, @affiliate.becomes(Organization))
    @account    = Account.for_affiliate(current_user.organization, @affiliate).first
  end

  def new_affiliate_from_params
    @affiliate ||= current_user.organization.affiliates.build(permitted_params(nil).affiliate)

  end

end
