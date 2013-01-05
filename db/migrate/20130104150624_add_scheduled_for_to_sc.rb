class AddScheduledForToSc < ActiveRecord::Migration
  def change
    add_column :tickets, :scheduled_for, :datetime
  end
end
