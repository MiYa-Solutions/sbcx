class SupportCommentController < ActiveAdmin::ResourceController
  def create
    @support_ticket  = SupportTicket.find(params[:commentable_id])
    @support_comment = SupportComment.new(support_ticket: @support_ticket)

    if @support_comment.save
      redirect_to @support_ticket
    else
      render :new
    end
  end

end