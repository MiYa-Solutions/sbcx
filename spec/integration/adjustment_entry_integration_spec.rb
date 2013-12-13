require 'spec_helper'

describe 'Adjustment Entry Integration' do
  include_context 'adjustment shared tests'

  it 'entry created successfully' do
    expect(entry).to_not be_nil
  end

  it 'initiator account balance is changing upon creation', skip_entry: true do
    balance_before = subcon_acc.reload.balance
    entry
    expect(subcon_acc.reload.balance).to eq(balance_before + entry.amount)
    # for some reason the below is not working
    #expect { entry }.to change { subcon_acc.reload.balance }.by(- entry.amount)
  end

  it 'recipient account balance is changing upon creation', skip_entry: true do
    balance_before = prov_acc.reload.balance
    entry
    expect(prov_acc.reload.balance).to eq(balance_before - entry.amount)
    # for some reason the below is not working
    #expect { entry }.to change { prov_acc.reload.balance }.by(- entry.amount)
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

  include_context 'verify adjustment notification' do
    let(:notification_entry) { subcon_entry }
  end

  it_behaves_like 'both accounts submitted and in synch'

  context 'when accepted' do
    before do
      subcon_entry.accept unless example.metadata[:skip_accept]
    end

    include_context 'verify acceptance notification' do
      let(:notification_entry) { entry }
    end

    it 'initiator account status should be in synch', skip_accept: true do
      expect { subcon_entry.accept! }.to change { subcon_acc.reload.synch_status_name }.from(:adjustment_submitted).to(:in_synch)
    end

    it 'recipient account status should be in synch', skip_accept: true do
      expect { subcon_entry.accept! }.to change { prov_acc.reload.synch_status_name }.from(:adjustment_submitted).to(:in_synch)
    end

    it 'the subcon entry should be accepted' do
      expect(subcon_entry).to be_accepted
    end

    it 'the original entry should be accepted' do
      expect(entry.reload).to be_accepted
    end

    it 'the account balance difference should be zero' do
      expect(subcon_acc.reload.balance + prov_acc.reload.balance).to eq 0
    end


  end

  context 'when rejected by the recipient' do
    before do
      subcon_entry.reject! unless example.metadata[:skip_reject]
    end

    include_context 'verify rejection notification' do
      let(:notification_entry) { entry }
    end

    it 'the initiator account balance should NOT be updated when rejected', skip_reject: true do
      expect { subcon_entry.reject! }.to_not change { subcon_acc.reload.balance }
    end

    it 'the recipient account balance should be updated when rejected', skip_reject: true do
      expect { subcon_entry.reject! }.to change { prov_acc.reload.balance }.by(entry.amount)
    end

    it 'the account balance difference should not be zero' do
      expect(subcon_acc.balance + prov_acc.balance).to_not eq 0
    end

    it 'initiator account status should be out of synch', skip_reject: true do
      expect { subcon_entry.reject! }.to change { subcon_acc.reload.synch_status_name }.from(:adjustment_submitted).to(:out_of_synch)
    end

    it 'recipient account status should be out of synch', skip_reject: true do
      expect { subcon_entry.reject! }.to change { prov_acc.reload.synch_status_name }.from(:adjustment_submitted).to(:out_of_synch)
    end

    it 'the subcon entry should be rejected' do
      expect(subcon_entry).to be_rejected
    end

    it 'the original entry should be rejected' do
      expect(entry.reload).to be_rejected
    end

    context 'when canceled by the initiator' do
      before do
        entry.reload.cancel! unless example.metadata[:skip_cancel]
      end

      it 'initiator account status should be back in synch', skip_cancel: true do
        expect { entry.reload.cancel! }.to change { subcon_acc.reload.synch_status_name }.from(:out_of_synch).to(:in_synch)
      end

      it 'recipient account status should be back in synch', skip_cancel: true do
        expect { entry.reload.cancel! }.to change { prov_acc.reload.synch_status_name }.from(:out_of_synch).to(:in_synch)
      end

      it 'the initiator account balance should be updated when canceled', skip_cancel: true do
        expect { entry.reload.cancel! }.to change { subcon_acc.reload.balance }.by(-entry.amount)
      end

      it 'the recipient account balance should NOT be updated when canceled', skip_cancel: true do
        expect { entry.reload.cancel! }.to_not change { prov_acc.reload.balance }
      end

      it 'the account balance difference should be back to zero' do
        expect(subcon_acc.reload.balance + prov_acc.reload.balance).to eq 0
      end

      it 'the subcon entry should be canceled' do
        expect(subcon_entry.reload).to be_canceled
      end

      it 'the original entry should be canceled' do
        expect(entry).to be_canceled
      end

      include_context 'verify cancellation notification' do
        let(:notification_entry) { subcon_entry.reload }
      end

    end

  end

  context 'when the recipient of the first entry creates another entry' do
    it_behaves_like 'when more then one entry is created' do
      let(:second_entry) { create_adj_entry_for_ticket(prov_acc, 100, subcon_job) }
    end
  end

  context 'when the initiator of the first entry creates another entry' do
    it_behaves_like 'when more then one entry is created' do
      let(:second_entry) { create_adj_entry_for_ticket(subcon_acc, 30, job) }
    end
  end

end