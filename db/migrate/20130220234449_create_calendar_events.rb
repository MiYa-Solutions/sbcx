class CreateCalendarEvents < ActiveRecord::Migration
  def change
    create_table :calendar_events do |t|
      t.datetime :starts_at
      t.datetime :ends_at
      t.string :title
      t.text :description
      t.boolean :all_day
      t.boolean :recurring
      t.integer :schedulable_id
      t.string :scheduable_type

      t.timestamps
    end
  end
end
