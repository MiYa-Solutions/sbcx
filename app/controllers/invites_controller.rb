class InvitesController < ApplicationController

  before_filter :authenticate_user!
  filter_resource_access

  # GET /invites
  # GET /invites.json
  def index
    @invites = Invite.find_all_by_organization_id(current_user.organization_id)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @invites }
    end
  end

  # GET /invites/1
  # GET /invites/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @invite }
    end
  end

  # GET /invites/new
  # GET /invites/new.json
  def new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @invite }
    end
  end

  # GET /invites/1/edit
  def edit
    @invite = Invite.find(params[:id])
  end

  # POST /invites
  # POST /invites.json
  def create
    respond_to do |format|
      if @invite.save
        format.html { redirect_to @invite.affiliate.becomes(Affiliate), flash: { success: 'Invite was successfully created.' } }
        format.json { render json: @invite, status: :created, location: @invite }
      else
        format.html { render action: "new" }
        format.json { render json: @invite.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /invites/1
  # PATCH/PUT /invites/1.json
  def update
    respond_to do |format|
      if @invite.update_attributes(invite_params)
        format.html { redirect_to @invite, notice: 'Invite was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @invite.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /invites/1
  # DELETE /invites/1.json
  def destroy
    @invite = Invite.find(params[:id])
    @invite.destroy

    respond_to do |format|
      format.html { redirect_to invites_url }
      format.json { head :no_content }
    end
  end

  def new_invite_from_params
    if invite_params[:affiliate_id].nil? || invite_params[:affiliate_id].empty?
      raise "Missing the affiliate id - you must specify the id of the affiliate you would like to send an invite to"
    end
    additional_params = invite_params.merge(organization_id: current_user.organization_id)
    additional_params = additional_params.merge(affiliate: Organization.find(invite_params[:affiliate_id]))


    @invite ||= current_user.organization.invites.build(additional_params)

  end

  def load_invite
    @invite = Invite.find(params[:id])
  end

  private

  # Use this method to whitelist the permissible parameters. Example:
  # params.require(:person).permit(:name, :age)
  # Also, you can specialize this method with per-user checking of permissible attributes.
  def invite_params
    params.require(:invite).permit(:affiliate_id, :message, :status_event)
  end


end
