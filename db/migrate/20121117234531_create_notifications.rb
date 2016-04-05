class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :subject
      t.text :content
      t.integer :status
      t.integer :user_id

      t.timestamps
    end
  end
end
