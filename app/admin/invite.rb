ActiveAdmin.register Invite do

  filter :organization, as: :select, collection: proc { Organization.where(subcontrax_member: true).order('name asc') }
  filter :affiliate
  filter :message
  filter :status
  filter :created_at
  filter :updated_at

  index do
    column :id do |invite|
      link_to invite.id, admin_invite_path(invite)
    end
    column :status do |invite|
      invite.human_status_name
    end

    column :message
    column :created_at
    column :updated_at
    column :creator
    column :updater

  end

end
