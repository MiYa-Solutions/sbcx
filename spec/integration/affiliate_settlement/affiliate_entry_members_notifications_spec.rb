require 'spec_helper'

describe 'Affiliate Entry For Members' do
  include_context 'transferred job'

  context 'when completing the work' do
    before do
      transfer_the_job
      accept_the_job subcon_job
      start_the_job subcon_job
      add_bom_to_job subcon_job, cost: 100, price: 1000, quantity: 1
      complete_the_work subcon_job
      job.reload
    end

    let(:subcon_entry) { subcon_job.provider_entries.last }
    let(:provider_entry) { job.subcon_entries.last }

    context 'when the provider initiates the settlement' do

      it 'should send a ScProviderSettledNotification to the subcon user' do
        expect {
          with_user(org_admin) do
            settle_with_subcon job, type: 'cheque', amount: '10'
          end
        }.to change(subcon_admin.notifications.where(type: 'ScProviderSettledNotification'), :size).by(1)
      end

      context 'when the subcon confirms the payment' do
        before do
          with_user(org_admin) do
            settle_with_subcon job, type: 'cheque', amount: '10'
          end
        end

        it 'should send a ScSubconConfirmedSettledNotification to the provider user' do
          expect {
            with_user(subcon_admin) do
              subcon_entry.confirm!
            end
          }.to_not change(org_admin.notifications.where(type: 'ScSubconConfirmedSettledNotification'), :size)
        end

        it 'should send a AffPaymentConfirmedNotification to the provider user' do
          expect {
            with_user(subcon_admin) do
              subcon_entry.confirm!
            end
          }.to change(org_admin.notifications.where(type: 'AffPaymentConfirmedNotification'), :size).by(1)
        end

        context 'when the subcon deposits the payment' do
          before do
            with_user(org_admin) do
              settle_with_subcon job, type: 'cheque', amount: '10'
            end
            with_user(subcon_admin) do
              subcon_entry.confirm!
            end
          end

          it 'should send a ScSubconDepositedNotification to the provider user' do
            expect {
              with_user(subcon_admin) do
                subcon_entry.deposit!
              end
            }.to_not change(org_admin.notifications.where(type: 'ScSubconDepositedNotification'), :size).by(1)
          end

          it 'should send a AffPaymentDepositedNotification to the provider user' do
            expect {
              with_user(subcon_admin) do
                subcon_entry.deposit!
              end
            }.to change(org_admin.notifications.where(type: 'AffPaymentDepositedNotification'), :size).by(1)
          end



        end
      end

    end

    context 'when the subcon initiates the settlement' do

      it 'should send a ScSubconSettledNotification to the provider user' do
        expect {
          with_user(subcon_admin) do
            settle_with_provider subcon_job, amount: 10, type: 'cheque'
          end
        }.to change(org_admin.notifications.where(type: 'ScSubconSettledNotification'), :size).by(1)
      end


      context 'when the subcon confirms' do
        before do
          with_user(subcon_admin) do
            settle_with_provider subcon_job, amount: 10, type: 'cheque'
          end

        end
        it 'should send a AffPaymentConfirmedNotification to the provider user' do
          expect {
            with_user(subcon_admin) do
              subcon_entry.confirm!
            end
          }.to change(org_admin.notifications.where(type: 'AffPaymentConfirmedNotification'), :size).by(1)
        end

        context 'when the subcon deposits the cheque' do
          before do
            with_user(subcon_admin) do
              subcon_entry.confirm!
              subcon_entry.deposit!
            end
          end

          context 'when the cheque is rejected' do
            it 'should send a AffPaymentRejectedNotification to the provider user' do
              expect {
                with_user(subcon_admin) do
                  subcon_entry.reject!
                end
              }.to change(org_admin.notifications.where(type: 'AffPaymentRejectedNotification'), :size).by(1)
            end

          end

          context 'when the prov initiates the settlement' do
            let(:subcon_entry2) { subcon_job.reload.provider_entries.last }
            let(:provider_entry2) { job.reload.subcon_entries.last }

            it 'should send a ScProviderSettledNotification to the provider user' do
              expect {
                with_user(org_admin) do
                  settle_with_subcon job, amount: 20, type: 'credit_card'
                end
              }.to change(subcon_admin.notifications.where(type: 'ScProviderSettledNotification'), :size).by(1)
            end

            context 'when the subcon confirms' do
              before do
                with_user(org_admin) do
                  settle_with_subcon job, amount: 20, type: 'credit_card'
                end

                with_user(subcon_admin) do
                  subcon_entry2.confirm!
                end
              end

              context 'when the subcon deposits the cheque' do
                before do
                  with_user(subcon_admin) do
                    subcon_entry2.deposit!
                  end
                end

                context 'when the subcon clears the cheque' do

                  it 'should send a AffPaymentClearedNotification to the provider user' do
                    expect {
                      with_user(subcon_admin) do
                        subcon_entry.clear!
                      end
                    }.to change(org_admin.notifications.where(type: 'AffPaymentClearedNotification'), :size).by(1)
                  end

                end

              end

            end

          end

        end
      end
    end
  end

end