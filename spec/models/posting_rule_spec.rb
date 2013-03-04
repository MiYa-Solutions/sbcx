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

describe PostingRule do

  let(:rule) { PostingRule.new }
  subject { rule }

  it "should have the expected attributes and methods" do
    should respond_to(:agreement_id)
    should respond_to(:type)
    should respond_to(:rate)
    should respond_to(:rate_type)
    should respond_to(:properties)

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
