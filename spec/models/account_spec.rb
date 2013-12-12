# == Schema Information
#
# Table name: accounts
#
#  id               :integer          not null, primary key
#  organization_id  :integer          not null
#  accountable_id   :integer          not null
#  accountable_type :string(255)      not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  balance_cents    :integer          default(0), not null
#  balance_currency :string(255)      default("USD"), not null
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
    should respond_to(:synch_status)
    expect(account).to respond_to(:adjustment_accepted)
    expect(account).to respond_to(:rejected_adj_entries)
    expect(account).to respond_to(:adjustment_rejected)
    expect(account).to respond_to(:adjustment_canceled)


  end

  context 'synch state machine' do

    it 'should have the proper constants' do
      expect(account.class).to have_constant(:SYNCH_STATUS_NA)
      expect(account.class).to have_constant(:SYNCH_STATUS_IN_SYNCH)
      expect(account.class).to have_constant(:SYNCH_STATUS_OUT_OF_SYNCH)
      expect(account.class).to have_constant(:SYNCH_STATUS_ADJ_SUBMITTED)
    end

    it 'should create the expected scope' do
      expect(account.class).to respond_to(:with_synch_statuses)
    end

    it 'should have the proper statuses' do
      expect(account).to respond_to(:synch_na?)
      expect(account).to respond_to(:in_synch?)
      expect(account).to respond_to(:out_of_synch?)
      expect(account).to respond_to(:adjustment_submitted?)
    end

    it 'the events should be made private' do
      expect(account).to_not respond_to(:synch)
      expect(account).to_not respond_to(:un_synch)
    end


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
    it { should have_many(:events) }
  end


end
