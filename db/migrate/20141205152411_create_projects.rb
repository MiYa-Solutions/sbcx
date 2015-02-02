class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.integer :status
      t.text :description

      t.userstamps(true)
      t.timestamps

    end

    add_column :tickets, :project_id, :integer
    add_index :tickets, :project_id
    add_index :projects, :name
  end
end
