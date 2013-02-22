class RenameScheduableToAppopintable < ActiveRecord::Migration
  def change
    rename_column :appointments, :schedulable_id, :appointable_id
    rename_column :appointments, :scheduable_type, :appointable_type
  end
end
