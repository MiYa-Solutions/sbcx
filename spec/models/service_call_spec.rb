# == Schema Information
#
# Table name: service_calls
#
#  id              :integer         not null, primary key
#  customer_id     :integer
#  notes           :text
#  started_on      :datetime
#  organization_id :integer
#  completed_on    :datetime
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#

require 'spec_helper'

describe ServiceCall do
  pending "add some examples to (or delete) #{__FILE__}"
end
