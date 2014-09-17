class CreateSupportTickets < ActiveRecord::Migration
  def change
    create_table :support_tickets do |t|
      t.string :subject
      t.text :description
      t.integer :status
      t.references :organization
      t.timestamps
      t.userstamps
    end

    add_index :support_tickets, :organization_id
    add_index :support_tickets, :creator_id
  end
end
