# == Schema Information
#
# Table name: payments
#
#  id           :integer          not null, primary key
#  agreement_id :integer
#  type         :string(255)
#  rate         :float
#  rate_type    :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'spec_helper'

describe Payment do
  pending "add some examples to (or delete) #{__FILE__}"
end
