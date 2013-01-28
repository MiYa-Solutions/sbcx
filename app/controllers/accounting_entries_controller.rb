class AccountingEntriesController < ApplicationController
  # GET /accounting_entries
  # GET /accounting_entries.json
  def index
    @accounting_entries = AccountingEntry.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @accounting_entries }
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
    @accounting_entry = AccountingEntry.new(accounting_entry_params)

    respond_to do |format|
      if @accounting_entry.save
        format.html { redirect_to @accounting_entry, notice: 'Accounting entry was successfully created.' }
        format.json { render json: @accounting_entry, status: :created, location: @accounting_entry }
      else
        format.html { render action: "new" }
        format.json { render json: @accounting_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /accounting_entries/1
  # PATCH/PUT /accounting_entries/1.json
  def update
    @accounting_entry = AccountingEntry.find(params[:id])

    respond_to do |format|
      if @accounting_entry.update_attributes(accounting_entry_params)
        format.html { redirect_to @accounting_entry, notice: 'Accounting entry was successfully updated.' }
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

  private

  # Use this method to whitelist the permissible parameters. Example:
  # params.require(:person).permit(:name, :age)
  # Also, you can specialize this method with per-user checking of permissible attributes.
  def accounting_entry_params
    params.require(:accounting_entry).permit(:account_id, :amount_cents, :amount_currency, :event_id, :status, :ticket_id)
  end
end
