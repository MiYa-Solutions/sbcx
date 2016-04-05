require 'spec_helper'

describe 'Member Provider Settlement: When claimed_p_settled' do

  include_context 'transferred job'

  before do
    transfer_the_job
    accept_the_job subcon_job
    job.reload
    with_user(org_admin) do
      settle_with_subcon job, amount: 10, type: 'cheque'
    end

  end

  let(:subcon_entry1) { subcon_job.entries.where(type: AffiliateSettlementEntry.descendants.map(&:name)).order('id asc').first }

  it 'provider status should be claimed_p_settled' do
    expect(subcon_job.reload.provider_status_name).to eq :claimed_p_settled
  end

  context 'when the subcon settles for another partial amount' do
    before do
      subcon_job.reload
      with_user(subcon_admin) do
        settle_with_provider subcon_job, amount: 10, type: 'credit_card'
      end
      subcon_job.reload
    end

    it 'should not change the provider status' do
      expect(subcon_job.provider_status_name).to eq :claimed_p_settled
    end

    context 'when confirming the provider settlement entry' do
      before do
        subcon_entry1.confirm!
        subcon_job.reload
      end

      it 'provider status should remain claimed_p_settled' do
        expect(subcon_job.provider_status_name).to eq :claimed_p_settled
      end

    end
  end

  context 'when the subcon confirms the settlement entry' do
    before do
      subcon_entry1.confirm!
    end

    it 'should change he provider status to partially_settled' do
      expect(subcon_job.reload.provider_status_name).to eq :partially_settled
    end

    it 'provider entry is set to confirmed' do
      expect(subcon_entry1.matching_entry.reload.status_name).to eq :confirmed
    end

  end

  context 'when the subcon disputes the settlement entry' do
    before do
      subcon_entry1.dispute!
      subcon_job.reload
    end

    it 'provider entry is set to disputed' do
      expect(subcon_entry1.matching_entry.reload.status_name).to eq :disputed
    end

    it 'should change the provider status to disputed' do
      expect(subcon_job.provider_status_name).to eq :disputed
    end
  end

  context 'when competing the job' do
    before do
      start_the_job subcon_job
      add_bom_to_job subcon_job, cost: 10, price: 100, buyer: subcon, quantity: 1
      complete_the_work subcon_job
      subcon_job.reload
    end

    it 'should have a balance of 100 (as the bom reimbursement was already paid)' do
      expect(subcon_job.provider_balance).to eq Money.new(10000)
    end

    context 'when settling for the remaining amount' do
      before do
        settle_with_subcon job, amount: 100, type: 'credit_card'
        subcon_job.reload
      end

      it 'should change the status to claimed_as_settled' do
        expect(subcon_job.provider_status_name).to eq :claimed_as_settled
      end

    end

    context 'when the subcon confirms the settlement' do
      before do
        subcon_entry1.confirm!
        subcon_job.reload
      end

      it 'should change the status to partially_settled' do
        expect(subcon_job.provider_status_name).to eq :partially_settled
      end

      context 'when the subcon collects the reminder' do
        let(:subcon_entry2) { subcon_job.entries.where(type: AffiliateSettlementEntry.descendants.map(&:name)).order('id asc').last }

        before do
          with_user(subcon_admin) do
            settle_with_provider subcon_job, amount: 100, type: 'cheque'
          end
          subcon_job.reload
        end

        it 'should change the status to settled' do
          expect(subcon_job.provider_status_name).to eq :settled
        end

        it 'should change provider balance to zero' do
          expect(subcon_job.provider_balance).to eq Money.new(0)
        end

        context 'when depositing the first payment' do

          before do
            with_user(subcon_admin) do
              subcon_entry1.deposit!
            end
            subcon_job.reload
          end

          it 'status should remain settled' do
            expect(subcon_job.provider_status_name).to eq :settled
          end

          context 'when clearing the first payment' do
            before do
              with_user(subcon_admin) do
                subcon_entry1.clear!
              end
              subcon_job.reload

            end

            it 'status should remain settled' do
              expect(subcon_job.provider_status_name).to eq :settled
            end

            context 'when confirming the second payment' do
              before do
                with_user(subcon_admin) do
                  subcon_entry2.confirm!
                end
                subcon_job.reload
              end

              it 'status should remain settled' do
                expect(subcon_job.provider_status_name).to eq :settled
              end

              context 'when depositing the second payment' do
                before do
                  with_user(subcon_admin) do
                    subcon_entry2.deposit!
                  end
                  subcon_job.reload
                end

                it 'status should remain settled' do
                  expect(subcon_job.provider_status_name).to eq :settled
                end

                context 'when clearing the second payment' do
                  before do
                    with_user(subcon_admin) do
                      subcon_entry2.clear!
                    end
                    subcon_job.reload

                  end

                  it 'status should change to cleared' do
                    expect(subcon_job.provider_status_name).to eq :cleared
                  end

                end

              end


            end

          end

        end
      end
    end
  end

  context 'before completing the work' do
    context 'when the provider pays the subcon the reminder' do
      before do
        settle_with_subcon job, amount: 100, type: 'credit_card'
        subcon_job.reload
      end

      it 'provider status should remain claimed_p_settled' do
        expect(subcon_job.provider_status_name).to eq :claimed_p_settled
      end

      context 'when the sucbon confirms the first payment' do
        before do
          with_user(subcon_admin) do
            subcon_entry1.confirm!
          end
          subcon_job.reload
        end
        it 'provider status should remain claimed_p_settled' do
          expect(subcon_job.provider_status_name).to eq :claimed_p_settled
        end

      end

      context 'when competing the work' do
        before do
          start_the_job subcon_job
          add_bom_to_job subcon_job, cost: 10, price: 100, buyer: subcon, quantity: 1
          subcon_job.reload
          complete_the_work subcon_job
          subcon_job.reload
        end

        it 'provider status should change to claimed_as_settled' do
          expect(subcon_job.provider_status_name).to eq :claimed_as_settled
        end

      end


    end
  end

end