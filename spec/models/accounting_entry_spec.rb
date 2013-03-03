# == Schema Information
#
# Table name: accounting_entries
#
#  id               :integer         not null, primary key
#  status           :integer
#  event_id         :integer
#  amount_cents     :integer         default(0), not null
#  amount_currency  :string(255)     default("USD"), not null
#  ticket_id        :integer
#  account_id       :integer
#  created_at       :datetime        not null
#  updated_at       :datetime        not null
#  type             :string(255)
#  description      :string(255)
#  balance_cents    :integer         default(0), not null
#  balance_currency :string(255)     default("USD"), not null
#

require 'spec_helper'

describe AccountingEntry do

  let(:entry) { AccountingEntry.new }
  subject { entry }

  it "should have the expected attributes and methods" do
    should respond_to(:account_id)
    should respond_to(:event_id)
    should respond_to(:status)
    should respond_to(:amount_cents)
    should respond_to(:amount_currency)
    should respond_to(:ticket_id)
    should respond_to(:type)
    should respond_to(:description)
  end

  describe "validation" do
    before { entry.valid? }
    [:account_id, :status, :ticket_id, :event_id, :type, :description].each do |attr|
      it "must have a #{attr}" do

        entry.errors[attr].should_not be_empty
      end
    end

    it "amount should be Money object" do
      entry.amount.should be_a Money
    end
  end

  describe "associations" do
    it { should belong_to(:account) }
    it { should belong_to(:ticket) }
  end

end
