class PostingRulesController < ApplicationController
  filter_resource_access
  # GET /posting_rules
  # GET /posting_rules.json
  def index
    @agreement     = Agreement.find(params[:agreement_id])
    @posting_rules = @agreement.posting_rules

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posting_rules }
    end
  end

  # GET /posting_rules/1
  # GET /posting_rules/1.json
  def show
    @posting_rule = PostingRule.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @posting_rule }
    end
  end

  # GET /posting_rules/new
  # GET /posting_rules/new.json
  def new

    respond_to do |format|
      format.html # new.html.erb
      format.js   # new.js.erb
      format.json { render json: @posting_rule }
    end
  end

  # GET /posting_rules/1/edit
  def edit
    #@posting_rule = PostingRule.find(params[:id])
  end

  # POST /posting_rules
  # POST /posting_rules.json
  def create

    respond_to do |format|
      if @posting_rule.save
        format.html { redirect_to @agreement.becomes(Agreement), notice: 'Posting rule was successfully created.' }
      else
        format.html { redirect_to @agreement.becomes(Agreement), alert: @posting_rule.errors.messages }
        format.js { render :new }
      end
    end
  end

  # PATCH/PUT /posting_rules/1
  # PATCH/PUT /posting_rules/1.json
  def update
    @posting_rule = PostingRule.find(params[:id])

    respond_to do |format|
      if @posting_rule.update_attributes(permitted_params(@posting_rule).posting_rule)
        format.html { redirect_to @posting_rule, notice: 'Posting rule was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @posting_rule.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posting_rules/1
  # DELETE /posting_rules/1.json
  def destroy
    @posting_rule = PostingRule.find(params[:id])
    @posting_rule.destroy

    respond_to do |format|
      format.html { redirect_to agreement_path(@posting_rule.agreement) }
      format.json { head :no_content }
    end
  end

  def new_posting_rule_from_params
    @agreement = Agreement.find(params[:agreement_id])

    if params[:posting_rule].nil?
      type          = params[:posting_rule_type]
      @posting_rule = PostingRule.new_posting_rule(type, @agreement.id)
    else
      type          = params[:posting_rule][:type]
      @posting_rule = PostingRule.new_rule_from_params(type, permitted_params(nil).posting_rule)
    end


  end

end
