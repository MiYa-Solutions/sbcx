class AddIndustryToOrganization < ActiveRecord::Migration
  def change
    add_column :organizations, :industry, :string
    add_column :organizations, :other_industry, :string
  end
end
