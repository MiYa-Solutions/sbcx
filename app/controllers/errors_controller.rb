class ErrorsController < ApplicationController
  def show
    @exception = env["action_dispatch.exception"] || Exception.new(params[:message])
    respond_to do |format|
      format.any(:html, :mobile) { render action: request.path[/\d{3}/], status: request.path[1..-1] }
      format.json { render json: { status: request.path[/\d{3}/], error: @exception.message }, status: request.path[/\d{3}/] }
    end
  end
end
