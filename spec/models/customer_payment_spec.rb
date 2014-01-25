# == Schema Information
#
# Table name: accounting_entries
#
#  id               :integer          not null, primary key
#  status           :integer
#  event_id         :integer
#  amount_cents     :integer          default(0), not null
#  amount_currency  :string(255)      default("USD"), not null
#  ticket_id        :integer
#  account_id       :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  type             :string(255)
#  description      :string(255)
#  balance_cents    :integer          default(0), not null
#  balance_currency :string(255)      default("USD"), not null
#  agreement_id     :integer
#

require 'spec_helper'

describe CustomerPayment do

  let(:org) { mock_model(Organization, id: 1) }
  let(:org2) { mock_model(Organization, id: 2) }
  let(:acc) { mock_model(Account, id: 1, organization: org, accountable: org2, changed_for_autosave?: true, save: true, events: []) }
  let(:event) { mock_model(Event, id: 1) }
  let(:ticket) { mock_model(Ticket, id: 1, save: true, ref_id: 1, organization: org) }
  let(:entry) { CustomerPayment.new(ticket: ticket, account: acc, event: event, description: 'test') }

  it 'should have a state machine constants defined for the various states' do
    expect(entry.class).to have_constant(:STATUS_PENDING)
    expect(entry.class).to have_constant(:STATUS_CLEARED)
    expect(entry.class).to have_constant(:STATUS_REJECTED)
  end


  it 'should respond to submitted?' do
    expect(entry).to respond_to(:pending?)
  end

  it 'should respond to rejected?' do
    expect(entry).to respond_to(:rejected?)
  end

  it 'should respond to accepted?' do
    expect(entry).to respond_to(:cleared?)
  end

  context 'when cleared' do


  end

  context 'when rejected' do

  end

end
