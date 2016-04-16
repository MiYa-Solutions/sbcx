ActiveAdmin.register User do
  filter :organization, collection: proc { Organization.where(subcontrax_member: true).all }
  filter :roles
  filter :name
  filter :last_name
  filter :phone

  index do
    column "ID" do |user|
      link_to user.id, admin_user_path(user)
    end
    column :email
    column "Organization" do |user|
      link_to user.organization.name, admin_organization_path(user.organization)
    end
    column :sign_in_count
    column :current_sign_in_at
    column :last_sign_in_at
    column :first_name
    column :last_name
    column :phone
    column :mobile_phone
    column :company
    column :address1
    column :address2
    column :country
    column :state
    column :city
    column :zip
    column :work_phone
    column :time_zone


    actions :defaults => false do |user|
      link_to "View", admin_user_path(user)
    end

  end

  # show do |u|
  #
  # end
  #

end
