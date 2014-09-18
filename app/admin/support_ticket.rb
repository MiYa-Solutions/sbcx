ActiveAdmin.register SupportTicket do
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
    panel "Customer Comments" do
      table_for(support_ticket.comments) do |t|
        t.column("Body") { |c| c.body }
        t.column("Actions") {|c| "#{link_to "Edit", edit_admin_support_comment_path(c)} | #{link_to "View", admin_support_comment_path(c)}".html_safe  }
      end

      render 'admin/support_comments/form', support_comment: SupportComment.new(support_ticket: support_ticket)
    end



    active_admin_comments
  end

  form do |f|
    f.inputs do
      f.input :status
      f.input :subject
      f.input :description
    end
    f.actions
  end


end
