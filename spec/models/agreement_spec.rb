# == Schema Information
#
# Table name: agreements
#
#  id               :integer         not null, primary key
#  name             :string(255)
#  subcontractor_id :integer
#  provider_id      :integer
#  description      :text
#  created_at       :datetime        not null
#  updated_at       :datetime        not null
#

require 'spec_helper'

describe Agreement do
  pending "add some examples to (or delete) #{__FILE__}"
end
