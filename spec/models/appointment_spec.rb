# == Schema Information
#
# Table name: calendar_events
#
#  id              :integer         not null, primary key
#  starts_at       :datetime
#  ends_at         :datetime
#  title           :string(255)
#  description     :text
#  all_day         :boolean
#  recurring       :boolean
#  schedulable_id  :integer
#  scheduable_type :string(255)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  creator_id      :integer
#  updater_id      :integer
#

require 'spec_helper'

describe Appointment do
  pending "add some examples to (or delete) #{__FILE__}"
end
