class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.string :message
      t.integer :organization_id
      t.integer :affiliate_id
      t.integer :status

      t.timestamps
    end
  end
end
