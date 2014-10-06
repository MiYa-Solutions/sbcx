class CommentsController < ApplicationController
  before_filter :authenticate_user!
  filter_resource_access

  # GET /comments
  # GET /comments.json
  def index
    @comments = Comment.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @comments }
    end
  end

  # GET /comments/1
  # GET /comments/1.json
  def show

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @comment }
    end
  end

  # GET /comments/new
  # GET /comments/new.json
  def new
    @comment = Comment.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @comment }
    end
  end

  # GET /comments/1/edit
  def edit
    @comment = Comment.find(params[:id])
  end

  # POST /comments
  # POST /comments.json
  def create
    respond_to do |format|
      if @comment.save
        format.js {
          render :create
        }
        format.html { redirect_to @comment, notice: 'Comment was successfully created.' }
        format.json { render json: @comment, status: :created, location: @comment }
      else
        format.js {
          render :js => "alert('error saving comment');"
        }
        format.html { render action: "new" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    @comment = Comment.find(params[:id])

    respond_to do |format|
      if @comment.update_attributes(comment_params)
        format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    begin
      @comment.destroy
    rescue ActiveRecord::RecordInvalid

    end
    respond_to do |format|
      format.js {  }
      format.html { render :json => @comment, :status => :ok }
      format.json { head :no_content }
    end
  end

  protected

  def new_comment_from_params
    @obj     = comment_params[:commentable_type].constantize.find(comment_params[:commentable_id])
    @comment = Comment.build_from(@obj, current_user.id, comment_params[:body])
  end

  private

  # Use this method to whitelist the permissible parameters. Example:
  # params.require(:person).permit(:name, :age)
  # Also, you can specialize this method with per-user checking of permissible attributes.
  def comment_params
    params.require(:comment).permit(:body, :commentable_id, :commentable_type)
  end
end
