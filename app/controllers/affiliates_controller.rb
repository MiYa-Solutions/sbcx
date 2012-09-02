class AffiliatesController < ApplicationController
  before_filter :authenticate_user!

  #filter_access_to :new, model: Organization
  #filter_access_to :create, model: Organization
  #filter_access_to :edit, model: Organization, attribute_check: true
  #filter_access_to :update, model: Organization, attribute_check: true
  #filter_access_to :show, model: Organization, attribute_check: true
  #filter_access_to :index, model: Organization
  #
  #filter_access_to :all, model: Organization, attribute_check: true
  filter_resource_access

  def new
    # no need for the below as declarative_authorization filter_resource_access takes care of it
    #@affiliate = Affiliate.new
  end

  def create

    params[:affiliate][:status_event] = :make_local
    if params[:affiliate][:organization_role_ids] && params[:affiliate][:organization_role_ids].include?(OrganizationRole::PROVIDER_ROLE_ID.to_s)
      @affiliate.agreements.new(subcontractor_id: current_user.organization.id, provider_id: @affiliate)
    end

    if params[:affiliate][:organization_role_ids] && params[:affiliate][:organization_role_ids].include?(OrganizationRole::SUBCONTRACTOR_ROLE_ID.to_s)
      @affiliate.reverse_agreements.new(provider_id: current_user.organization.id, subcontractor_id: @affiliate)
    end

    if @affiliate.save
      redirect_to @affiliate, :notice => t('affiliates.flash.create_affiliate_success', name: @affiliate.name)
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
    if @affiliate.update_attributes(params[:affiliate])
      redirect_to @affiliate, :notice => "Successfully updated provider."
    else
      render :action => :edit
    end
  end

  def index
    if params[:search].nil?
      @affiliates = Affiliate.my_affiliates(current_user.organization.id).paginate(page: params[:page], per_page: 10)
    else
      @affiliates = Affiliate.affiliate_search(current_user.organization.id, params[:search]).paginate(page: params[:page], per_page: 10)
    end
  end


  def show
    # no need for the below as declarative_authorization filter_resource_access takes care of it
    #@affiliate = Affiliate.find(params[:id])
  end

end
