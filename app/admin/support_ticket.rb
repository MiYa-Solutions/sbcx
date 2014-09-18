ActiveAdmin.register SupportTicket do
  def permitted_params
    params.permit(:other_parameter, :group => [:name, :description])
  end

  filter :name

  index do
    column "status", :status
    column "Organization" do |ticket|
      link_to ticket.organization.name, admin_organization_path(ticket.organization)
    end
    column :subject
    column :description

    actions :defaults => false do |post|
      link_to "View", admin_support_ticket_path(post)
    end

  end

  show do
    attributes_table do
      row "Organization" do |t|
        link_to t.organization.name, admin_organization_path(t.organization)
      end
      row :subject
      row :description
    end
    active_admin_comments
  end

  form do |f|
    # ...
    f.has_many :comments do |comment|
      comment.input :body
    end

    f.actions
  end


end
