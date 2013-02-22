class RenameCalendarEventToAppointment < ActiveRecord::Migration
  def up
    rename_table :calendar_events, :appointments
  end

  def down
    rename_table :appointments, :calendar_events
  end
end
