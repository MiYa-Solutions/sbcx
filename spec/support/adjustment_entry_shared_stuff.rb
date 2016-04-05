shared_context 'adjustment shared tests' do
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
  let(:subcon_entry) { AccountingEntry.find(entry.reload.event.affiliate_entry_id) }

  before do
    job.subcontractor    = subcon.becomes(Subcontractor)
    job.subcon_agreement = agreement
    job.transfer
    subcon_job.accept
    subcon_job.start_work
    add_bom_to_ticket subcon_job, 10, 100, 1, prov
    add_bom_to_ticket subcon_job, 20, 200, 1, subcon
    subcon_job.complete_work
    entry unless example.metadata[:skip_entry]
  end

  shared_examples 'create notification' do |klass, org_name|
    # must provide a notification_org context e.g. let(:notification_context) {org}
    it "#{klass} should be sent to #{org_name}" do
      expect(subject.notifications).to_not be_empty
      notifications = klass.find_all_by_notifiable_id_and_notifiable_type(subject.id, subject.class.table_name.classify)
      expect(notifications).to_not be_empty
      expect(notifications.map(&:user)).to eq notification_org.users
    end
  end

  shared_context 'verify adjustment notification' do
    subject { notification_entry }
    it_should 'create notification', AccountAdjustedNotification, 'adjustment initiator' do
      let(:notification_org) { notification_entry.account.organization }
    end
  end

  shared_context 'verify acceptance notification' do
    subject { notification_entry }
    it_should 'create notification', AccAdjAcceptedNotification, 'adjustment initiator' do
      let(:notification_org) { notification_entry.account.organization }
    end
  end

  shared_context 'verify rejection notification' do
    subject { notification_entry }
    it_should 'create notification', AccAdjRejectedNotification, 'adjustment initiator' do
      let(:notification_org) { notification_entry.account.organization }
    end
  end

  shared_context 'verify cancellation notification' do
    subject { notification_entry }
    it_should 'create notification', AccAdjCanceledNotification, 'adjustment recipient' do
      let(:notification_org) { notification_entry.account.organization }
    end
  end

  shared_examples 'both accounts balance is in synch (not status)' do
    it 'the account balance difference should be zero' do
      expect(subcon_acc.reload.balance + prov_acc.reload.balance).to eq 0
    end
  end

  shared_examples 'both accounts balance is NOT in synch (not status)' do
    it 'the account balance difference should be zero' do
      expect(subcon_acc.reload.balance + prov_acc.reload.balance).to_not eq 0
    end
  end

  shared_examples 'both accounts submitted and in synch' do
    it 'initiator account status should be submitted' do
      expect(subcon_acc.reload).to be_adjustment_submitted
    end

    it 'recipient account status should be submitted' do
      expect(prov_acc.reload).to be_adjustment_submitted
    end

    it_behaves_like 'both accounts balance is in synch (not status)'
  end

  shared_examples 'when more then one entry is created' do
    # assumes a second_entry context is passed e.g. let(:second_entry) { create_adj_entry_for_ticket(prov_acc, 100, subcon_job) }
    # assumes first entry is just submitted
    let(:matching_second_entry) { AccountingEntry.find second_entry.reload.event.affiliate_entry_id }
    before do
      second_entry.reload
    end
    it_behaves_like 'both accounts balance is in synch (not status)'

    context 'when accepting first entry' do
      before do
        subcon_entry.reload.accept! unless example.metadata[:skip_accept]
      end

      include_context 'verify acceptance notification' do
        let(:notification_entry) { entry.reload }
      end

      it 'original initiator account status should remain adjustment submitted in synch', skip_accept: true do
        expect { subcon_entry.accept! }.to_not change { subcon_acc.reload.synch_status_name }.from(:adjustment_submitted)
      end

      it_behaves_like 'both accounts balance is in synch (not status)'

      it 'original recipient account status should remain adjustment submitted in synch', skip_accept: true do
        expect { subcon_entry.accept! }.to_not change { prov_acc.reload.synch_status_name }.from(:adjustment_submitted)
      end

      context 'when accepting the second entry' do
        it 'original initiator account status should change to in synch' do
          expect { matching_second_entry.reload.accept! }.to change { subcon_acc.reload.synch_status_name }.from(:adjustment_submitted).to(:in_synch)
        end

        it 'original recipient account status should remain adjustment submitted in synch' do
          expect { matching_second_entry.reload.accept! }.to change { prov_acc.reload.synch_status_name }.from(:adjustment_submitted).to(:in_synch)
        end

        it_behaves_like 'both accounts balance is in synch (not status)'

        include_context 'verify acceptance notification' do
          let(:notification_entry) do
            matching_second_entry.accept!
            second_entry
          end
        end

      end

      context 'when rejecting the second entry' do
        before do
          matching_second_entry.reject! unless example.metadata[:skip_second_reject]
        end

        include_context 'verify rejection notification' do
          let(:notification_entry) { second_entry.reload }
        end

        it 'original initiator account status should change to in synch', skip_second_reject: true do
          expect { matching_second_entry.reload.reject! }.to change { subcon_acc.reload.synch_status_name }.from(:adjustment_submitted).to(:out_of_synch)
        end

        it 'original recipient account status should remain adjustment submitted in synch', skip_second_reject: true do
          expect { matching_second_entry.reload.reject! }.to change { prov_acc.reload.synch_status_name }.from(:adjustment_submitted).to(:out_of_synch)
        end

        it_behaves_like 'both accounts balance is NOT in synch (not status)'

        context 'when cancelling the second entry' do
          before do
            second_entry.reload.cancel! unless example.metadata[:skip_second_cancel]
          end
          it 'original initiator account status should change to in synch', skip_second_cancel: true do
            expect { second_entry.reload.cancel! }.to change { subcon_acc.reload.synch_status_name }.from(:out_of_synch).to(:in_synch)
          end

          it 'original recipient account status should remain adjustment submitted in synch', skip_second_cancel: true do
            expect { second_entry.reload.cancel! }.to change { prov_acc.reload.synch_status_name }.from(:out_of_synch).to(:in_synch)
          end

          it_behaves_like 'both accounts balance is in synch (not status)'

          include_context 'verify cancellation notification' do
            let(:notification_entry) { matching_second_entry.reload }
          end

        end
      end
    end

    context 'when rejecting first entry' do
      before do
        subcon_entry.reload.reject! unless example.metadata[:skip_reject]
      end

      it 'original initiator account status should change from adjustment submitted to out of synch', skip_reject: true do
        expect { subcon_entry.reload.reject! }.to change { subcon_acc.reload.synch_status_name }.from(:adjustment_submitted).to(:out_of_synch)
      end

      it_behaves_like 'both accounts balance is NOT in synch (not status)'

      it 'original recipient account status should remain adjustment submitted in synch', skip_reject: true do
        expect { subcon_entry.reload.reject! }.to change { prov_acc.reload.synch_status_name }.from(:adjustment_submitted).to(:out_of_synch)
      end


      context 'when accepting the second entry' do

        before do
          matching_second_entry.reload.accept! unless example.metadata[:skip_second_accept]
        end

        include_context 'verify acceptance notification' do
          let(:notification_entry) { second_entry.reload }
        end

        it 'adj initiator account status should remain out of synch', skip_second_accept: true do
          expect { matching_second_entry.reload.accept! }.to_not change { subcon_acc.reload.synch_status_name }.from(:out_of_synch)
        end

        it 'adj recipient account status should remain out of synch', skip_second_accept: true do
          expect { matching_second_entry.accept! }.to_not change { prov_acc.reload.synch_status_name }.from(:out_of_synch)
        end

        it_behaves_like 'both accounts balance is NOT in synch (not status)'
      end


    end
  end
end
