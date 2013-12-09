require 'spec_helper'

describe AdjustmentEntry do

  let(:entry) { AdjustmentEntry.new }

  context 'validation' do
    it { expect(entry).to validate_numericality_of(:ticket_ref_id) }
    it { expect(entry).to_not validate_presence_of(:agreement) }
  end

  context 'association' do
    it { expect(entry).to belong_to(:ticket) }

  end

  context 'api' do
    it 'sets the ticket to be the one specified in ticket_ref_id' do
      #ticket = FactoryGirl.create(:my_service_call)
      #entry.ticket_ref_id = ticket.id
      #expect(entry.save).to be_true
      #
      #expect(entry.ticket).to be ticket
      pending
    end
  end
end