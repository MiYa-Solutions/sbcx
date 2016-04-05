class SetDefaultStatusForUsers < ActiveRecord::Migration
  def up
    User.all.each do |user|
      user.status = User::STATUS_ACTIVE
      user.save!
    end
  end

  def down
  end
end
