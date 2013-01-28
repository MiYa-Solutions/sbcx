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
