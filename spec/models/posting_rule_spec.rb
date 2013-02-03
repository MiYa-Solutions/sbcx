# == Schema Information
#
# Table name: posting_rules
#
#  id           :integer         not null, primary key
#  agreement_id :integer
#  type         :string(255)
#  rate         :decimal(, )
#  rate_type    :string(255)
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#  properties   :hstore
#

require 'spec_helper'

describe PostingRule do

  let(:rule) { PostingRule.new }
  subject { rule }

  it "should have the expected attributes and methods" do
    should respond_to(:agreement_id)
    should respond_to(:type)
    should respond_to(:rate)
    should respond_to(:rate_type)

    should respond_to(:time_bound)
    should respond_to(:sunday)
    should respond_to(:monday)
    should respond_to(:tuesday)
    should respond_to(:wednesday)
    should respond_to(:thursday)
    should respond_to(:friday)
    should respond_to(:saturday)

    should respond_to(:sunday_from)
    should respond_to(:monday_from)
    should respond_to(:tuesday_from)
    should respond_to(:wednesday_from)
    should respond_to(:thursday_from)
    should respond_to(:friday_from)
    should respond_to(:saturday_from)

    should respond_to(:sunday_to)
    should respond_to(:monday_to)
    should respond_to(:tuesday_to)
    should respond_to(:wednesday_to)
    should respond_to(:thursday_to)
    should respond_to(:friday_to)
    should respond_to(:saturday_to)


  end

  describe "validation" do
    before { rule.valid? }
    [:agreement_id, :type, :rate, :rate_type].each do |attr|
      it "must have a #{attr}" do

        rule.errors[attr].should_not be_empty
      end
    end
  end

  describe "associations" do
    it { should belong_to(:agreement) }
  end

end
