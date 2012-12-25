# == Schema Information
#
# Table name: accounts
#
#  id               :integer         not null, primary key
#  organization_id  :integer         not null
#  accountable_id   :integer         not null
#  accountable_type :string(255)
#  created_at       :datetime        not null
#  updated_at       :datetime        not null
#

class Account < ActiveRecord::Base

  belongs_to :organization
  belongs_to :accountable, :polymorphic => true

end
