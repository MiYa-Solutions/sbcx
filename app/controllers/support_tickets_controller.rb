class SupportTicketsController < ApplicationController

  filter_resource_access

  # GET /support_tickets
  # GET /support_tickets.json
  def index
    @support_tickets = SupportTicket.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @support_tickets }
    end
  end

  # GET /support_tickets/1
  # GET /support_tickets/1.json
  def show

    @comments = @support_ticket.comment_threads.order('created_at desc')
    @new_comment = Comment.build_from(@support_ticket, current_user.id, "")
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @support_ticket }
    end
  end

  # GET /support_tickets/new
  # GET /support_tickets/new.json
  def new
    @support_ticket = SupportTicket.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @support_ticket }
    end
  end

  # GET /support_tickets/1/edit
  def edit
    @support_ticket = SupportTicket.find(params[:id])
  end

  # POST /support_tickets
  # POST /support_tickets.json
  def create
    respond_to do |format|
      if @support_ticket.save
        format.html { redirect_to @support_ticket, notice: 'Support ticket was successfully created.' }
        format.json { render json: @support_ticket, status: :created, location: @support_ticket }
      else
        format.html { render action: "new" }
        format.json { render json: @support_ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /support_tickets/1
  # PATCH/PUT /support_tickets/1.json
  def update
    @support_ticket = SupportTicket.find(params[:id])

    respond_to do |format|
      if @support_ticket.update_attributes(support_ticket_params)
        format.html { redirect_to @support_ticket, notice: 'Support ticket was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @support_ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /support_tickets/1
  # DELETE /support_tickets/1.json
  def destroy
    @support_ticket = SupportTicket.find(params[:id])
    @support_ticket.destroy

    respond_to do |format|
      format.html { redirect_to support_tickets_url }
      format.json { head :no_content }
    end
  end

  protected

  def new_support_ticket_from_params
    the_params                   = support_ticket_params
    the_params[:organization_id] = current_user.organization_id

    @support_ticket = SupportTicket.new(the_params)
  end

  private


  # Use this method to whitelist the permissible parameters. Example:
  # params.require(:person).permit(:name, :age)
  # Also, you can specialize this method with per-user checking of permissible attributes.
  def support_ticket_params
    params.require(:support_ticket).permit(:subject, :description, :status_event)
  end
end
