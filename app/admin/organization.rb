ActiveAdmin.register Organization do
  scope :members
  scope :all

  filter :subcontrax_member

  #filter :subcontrax_member
  filter :name
  filter :created_at
  filter :industry
  filter :other_industry
  index do
    column "Mamber?", :subcontrax_member
    column "Status" do |org|
      link_to org.human_status_name, admin_organization_path(org)
    end
    column :industry
    column :other_industry
    column :name do |org|
      link_to org.name, admin_organization_path(org)
    end
    column :company
    column :email
    column :phone
    column :mobile
    column :work_phone
    column :address1
    column :address2
    column :city
    column :state
    column :country
    column :zip

    actions :defaults => false do |post|
      link_to "View", admin_organization_path(post)
    end

  end

  show do |ad|
    attributes_table do
      row :subcontrax_member
      row "Status" do |org|
        link_to org.human_status_name, admin_organization_path(org)
      end
      row :industry
      row :other_industry
      row :name
      row :company
      row :email
      row :phone
      row :mobile
      row :work_phone
      row :address1
      row :address2
      row :city
      row :state
      row :country
      row :zip
    end
    panel 'Events' do
      paginated_collection(organization.events.page(params[:events_page]).per(5), param_name: 'events_page') do

        table_for collection do |event|
          column("Name") { |event| event.name }
          column("Created At") { |event| event.created_at }
          column("Created By") { |event| event.creator.name }
          column("Description") { |event| event.description }
        end
      end
    end
    active_admin_comments
  end

end
