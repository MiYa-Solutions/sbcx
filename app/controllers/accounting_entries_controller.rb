class AccountingEntriesController < ApplicationController
  # GET /accounting_entries
  # GET /accounting_entries.json
  before_filter :authenticate_user!
  filter_resource_access

  def index
    @account = Account.find(params[:accounting_entry][:account_id]) if params[:accounting_entry].present? && params[:accounting_entry][:account_id].present?
    @accounts = current_user.organization.accounts

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: EntriesDatatable.new(view_context, @account) }
    end
  end

  # GET /accounting_entries/1
  # GET /accounting_entries/1.json
  def show
    @accounting_entry = AccountingEntry.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @accounting_entry }
    end
  end

  # GET /accounting_entries/new
  # GET /accounting_entries/new.json
  def new
    @accounting_entry = AccountingEntry.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @accounting_entry }
    end
  end

  # GET /accounting_entries/1/edit
  def edit
    @accounting_entry = AccountingEntry.find(params[:id])
  end

  # POST /accounting_entries
  # POST /accounting_entries.json
  def create
    #@accounting_entry = AccountingEntry.new(accounting_entry_params)

    @account = Account.find(params[:accounting_entry][:account_id]).lock! if params[:accounting_entry].present? && params[:accounting_entry][:account_id].present?
    respond_to do |format|
      if @account && @account.entries << @accounting_entry
        format.html { redirect_to @accounting_entry.becomes(AccountingEntry), notice: 'Accounting entry was successfully created.' }
        format.json { render json: @accounting_entry, status: :created, location: @accounting_entry.becomes(AccountingEntry) }
      else
        format.html { render action: "new" }
        format.json { render json: @accounting_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /accounting_entries/1
  # PATCH/PUT /accounting_entries/1.json
  def update
    respond_to do |format|
      if @accounting_entry.update_attributes(accounting_entry_params)
        format.html { redirect_to @accounting_entry.becomes(AccountingEntry), :flash => { :success => 'Accounting entry was successfully updated.' } }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @accounting_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /accounting_entries/1
  # DELETE /accounting_entries/1.json
  def destroy
    @accounting_entry = AccountingEntry.find(params[:id])
    @accounting_entry.destroy

    respond_to do |format|
      format.html { redirect_to accounting_entries_url }
      format.json { head :no_content }
    end
  end

  def new_accounting_entry_from_params
    @accounting_entry = MyAdjEntry.new(accounting_entry_params)
  end

  private

  # Use this method to whitelist the permissible parameters. Example:
  # params.require(:person).permit(:name, :age)
  # Also, you can specialize this method with per-user checking of permissible attributes.
  def accounting_entry_params
    params.require(:accounting_entry).permit(*determine_params)
  end

  def determine_params
    [:account_id, :amount, :description, :ticket_ref_id] + event_param
  end

  def event_param
    if @accounting_entry
      @accounting_entry.allowed_status_events.include?(params[:accounting_entry][:status_event].try(:to_sym)) ? [:status_event] : []
    else
      []
    end
  end

end
