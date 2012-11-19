class ChangeNotifiableToNotifiableIdNotifications < ActiveRecord::Migration
  def up
    rename_column :notifications, :notifiable, :notifiable_id
  end

  def down
    rename_column :notifications, :notifiable_id, :notifiable
  end
end
