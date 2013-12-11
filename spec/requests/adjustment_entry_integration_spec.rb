require 'spec_helper'

describe 'Adjustment Entry Integration' do
  let(:prov) { FactoryGirl.create(:member) }
  let(:subcon) { FactoryGirl.create(:member) }
  let(:subcon_job) { Ticket.find_by_ref_id_and_organization_id(job.ref_id, subcon.id) }

  let(:agreement) { setup_profit_split_agreement(prov, subcon, 50) }
  let(:job) { FactoryGirl.create(:my_service_call, organization: agreement.organization, subcontractor: nil) }
  let(:customer) { job.customer }
  let(:customer_acc) { Account.for(prov, customer).first }
  let(:subcon_acc) { Account.for(prov, subcon).first }
  let(:prov_acc) { Account.for(subcon, prov).first }
  let(:entry) { create_adj_entry_for_ticket(subcon_acc, 100, job) }
  let(:my_adj_event) { AccountAdjustmentEvent.find_by_eventable_id_and_eventable_type(entry.account.id, Account) }
  let(:rec_adj_event) { AccountAdjustedEvent.find_by_triggering_event_id(my_adj_event.id) }
  let(:subcon_entry) { ReceivedAdjEntry.find_by_event_id(rec_adj_event.id) }

  before do
    job.subcontractor    = subcon.becomes(Subcontractor)
    job.subcon_agreement = agreement
    job.transfer
    subcon_job.accept
    subcon_job.start_work
    add_bom_to_ticket subcon_job, 10, 100, 1, prov
    add_bom_to_ticket subcon_job, 20, 200, 1, subcon
    subcon_job.complete_work
    entry
  end

  it 'entry created successfully' do
    expect(entry).to_not be_nil
  end

  it 'entry status is submitted' do
    expect(entry).to be_submitted
  end
  it 'subcon entry is created and status is pending' do
    expect(subcon_entry).to_not be_nil
    expect(subcon_entry).to be_instance_of(ReceivedAdjEntry)
    expect(subcon_entry).to be_pending
  end

  it 'entry can be accepted' do
    expect(entry).to be_can_accept
  end
  it 'entry can be rejected' do
    expect(entry).to be_can_reject
  end
  it 'subcon entry can be accepted' do
    expect(subcon_entry).to be_can_accept
  end
  it 'subcon entry can be rejected' do
    expect(subcon_entry).to be_can_reject
  end

  it 'notification should be sent to subcon' do
    pending
  end

  context 'when accepted' do
    before do
      subcon_entry.accept
    end

    it 'the subcon entry should be accepted' do
      expect(subcon_entry).to be_accepted
    end
    it 'the original entry should be accepted' do
      expect(entry.reload).to be_accepted
    end


  end

  context 'when rejected' do
    before do
      subcon_entry.reject
    end

    it 'the subcon entry should be accepted' do
      expect(subcon_entry).to be_rejected
    end
    it 'the original entry should be accepted' do
      expect(entry.reload).to be_rejected
    end


  end

  pending 'second adjustment entry for the same ticket with a different amount'

end