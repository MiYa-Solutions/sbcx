class AddUserstampsToCalendarEvent < ActiveRecord::Migration
  def change
    add_column :calendar_events, :creator_id, :integer
    add_column :calendar_events, :updater_id, :integer
  end
end
