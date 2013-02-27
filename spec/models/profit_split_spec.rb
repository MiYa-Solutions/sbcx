# == Schema Information
#
# Table name: posting_rules
#
#  id             :integer         not null, primary key
#  agreement_id   :integer
#  type           :string(255)
#  rate           :decimal(, )
#  rate_type      :string(255)
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#  properties     :hstore
#  time_bound     :boolean         default(FALSE)
#  sunday         :boolean         default(FALSE)
#  monday         :boolean         default(FALSE)
#  tuesday        :boolean         default(FALSE)
#  wednesday      :boolean         default(FALSE)
#  thursday       :boolean         default(FALSE)
#  friday         :boolean         default(FALSE)
#  saturday       :boolean         default(FALSE)
#  sunday_from    :time
#  monday_from    :time
#  tuesday_from   :time
#  wednesday_from :time
#  thursday_from  :time
#  friday_from    :time
#  saturday_from  :time
#  sunday_to      :time
#  monday_to      :time
#  tuesday_to     :time
#  wednesday_to   :time
#  thursday_to    :time
#  friday_to      :time
#  saturday_to    :time
#

require 'spec_helper'

describe ProfitSplit do

  let(:rule) { FactoryGirl.create(:profit_split) }
  subject { rule }

  it "should have only percentage as an option" do
    rate_types.should == [ :percentage ]
  end

  describe "validation" do

  end

  describe "associations" do
    it { should belong_to(:agreement) }
  end

end
