class AddTriggeringEventIdToEvents < ActiveRecord::Migration
  def change
    add_column :events, :triggering_event_id, :integer
  end
end
