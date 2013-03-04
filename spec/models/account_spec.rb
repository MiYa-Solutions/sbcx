# == Schema Information
#
# Table name: accounts
#
#  id               :integer         not null, primary key
#  organization_id  :integer         not null
#  accountable_id   :integer         not null
#  accountable_type :string(255)     not null
#  created_at       :datetime        not null
#  updated_at       :datetime        not null
#  balance_cents    :integer         default(0), not null
#  balance_currency :string(255)     default("USD"), not null
#

require 'spec_helper'

describe Account do
  let(:account) { Account.new }
  subject { account }

  it "should have the expected attributes and methods" do
    should respond_to(:organization_id)
    should respond_to(:accountable_id)
    should respond_to(:accountable_type)
    should respond_to(:current_balance)
    should respond_to(:balance)
  end

  describe "validation" do
    [:organization_id, :accountable_id, :accountable_type].each do |attr|
      it "must have a #{attr}" do
        should raise_exception # as a notification should not be instantiated and must have a subclass
        account.errors[attr].should_not be_nil
      end
    end
  end

  describe "associations" do
    it { should belong_to(:organization) }
    it { should belong_to(:accountable) }
    it { should have_many(:accounting_entries) }
  end


end
