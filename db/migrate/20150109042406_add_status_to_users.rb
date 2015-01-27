class AddStatusToUsers < ActiveRecord::Migration
  def change
    add_column :users, :status, :integer
    User.all.each do |user|
      user.update_attribute(:status, User::STATUS_ACTIVE)
    end
  end
end
