ActiveAdmin.register SupportComment do

  controller do
    def create
      #@support_ticket  = SupportTicket.find(params[:support_comment][:commentable_id])
      hash =  permitted_params
      hash[:support_comment][:user] =  current_admin_user.becomes(User)
      hash[:support_comment][:commentable_type] =  'SupportTicket'

      @support_comment = SupportComment.new(hash[:support_comment])

      if @support_comment.save
        redirect_to admin_support_ticket_path(@support_comment.support_ticket.becomes(SupportTicket))
      else
        render :new
      end
    end
  end
  filter :body

  form :partial => 'edit'
  #form do |f|
  #  f.inputs do
  #    f.input :public
  #    f.input :body
  #  end
  #
  #  f.actions
  #end
  #panel "Support Ticket" do
  #  attributes_table_for(support_comment.support_ticket) do
  #    [:subject, :description].each do |column|
  #      row column
  #    end
  #    row "Last Comment" do
  #      support_comment.support_ticket.comments.last.body
  #    end
  #  end
  #end

end
