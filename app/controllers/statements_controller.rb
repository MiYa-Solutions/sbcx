class StatementsController < ApplicationController
  before_filter :authenticate_user!
  filter_resource_access

  # GET /statements
  # GET /statements.json
  def index
    @statements = Statement.where(statementable_id: statement_params[:statementable_id], statementable_type: statement_params[:statementable_type])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: StatementsDatatable.new(view_context) }
    end
  end

  # GET /statements/1
  # GET /statements/1.json
  def show

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @statement }
      format.pdf do
        partial = params[:template].present? ? params[:template] : 'show'
        render pdf:                    "statement_#{@statement.id}",
               layout:                 'service_calls',
               template:               "statements/#{partial}.pdf",
               footer:                 { html: { template: 'layouts/_footer.pdf.erb' } },
               header:                 { html: { template: 'layouts/_header.pdf.erb' } },
               disable_internal_links: false


      end

    end
  end

  # POST /statements
  # POST /statements.json
  def create

    respond_to do |format|
      if @statement.save(StatementSerializer::CustomerStatementSerializer)
        format.html { redirect_to @statement, notice: 'Statement was successfully created.' }
        format.json { render json: @statement, status: :created, location: @statement }
      else
        format.html { render action: "new" }
        format.json { render json: @statement.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /statements/1
  # DELETE /statements/1.json
  def destroy
    @statement.destroy

    respond_to do |format|
      format.html { redirect_to statements_url }
      format.json { head :no_content }
    end
  end

  protected

  def new_statement_from_params
    @statement = Statement.new(statement_params)
  end

  private

    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def statement_params
      params.require(:statement).permit(:account_id, :notes)
    end
end
