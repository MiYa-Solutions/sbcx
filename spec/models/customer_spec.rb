# == Schema Information
#
# Table name: customers
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  organization_id :integer
#  company         :string(255)
#  address1        :string(255)
#  address2        :string(255)
#  city            :string(255)
#  state           :string(255)
#  zip             :string(255)
#  country         :string(255)
#  phone           :string(255)
#  mobile_phone    :string(255)
#  work_phone      :string(255)
#  email           :string(255)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#

require 'spec_helper'

describe Customer do
  pending "add some examples to (or delete) #{__FILE__}"
end
