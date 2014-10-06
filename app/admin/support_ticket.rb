ActiveAdmin.register SupportTicket do
  scope :the_new
  scope :the_open
  scope :the_closed
  scope :all

  filter :organization, as: :select, collection: proc { Organization.where(subcontrax_member: true).order('name asc') }

  index do
    column "ID" do |ticket|
      link_to ticket.id, admin_support_ticket_path(ticket)
    end
    column "Status" do |ticket|
      link_to ticket.human_status_name.titleize, admin_support_ticket_path(ticket)
    end
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
      row :status do
        support_ticket.human_status_name.titleize
      end
      row :subject
      row :description
    end
    panel "Customer Comments" do
      table_for(support_ticket.comments) do |t|
        t.column("Public?") { |c| c.public? }
        t.column("Body") { |c| c.body }
        t.column("Actions") { |c| "#{link_to "Edit", edit_admin_support_comment_path(c)} | #{link_to "View", admin_support_comment_path(c)}".html_safe }
      end

      render 'admin/support_comments/form', support_comment: SupportComment.new(support_ticket: support_ticket)
    end


    active_admin_comments
  end

  form do |f|
    f.inputs do
      f.input :status, as: :select, collection: SupportTicket.state_machines[:status].states
      f.input :subject
      f.input :description
    end
    f.actions
  end


end
