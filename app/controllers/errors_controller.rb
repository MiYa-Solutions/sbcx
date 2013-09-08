class ErrorsController < ApplicationController
  def show
    @exception = env["action_dispatch.exception"]
    respond_to do |format|
      format.html { render action: request.path[/\d{3}/], status: request.path[1..-1] }
      format.json { render json: { status: request.path[/\d{3}/], error: @exception.message } }
    end
  end
end
