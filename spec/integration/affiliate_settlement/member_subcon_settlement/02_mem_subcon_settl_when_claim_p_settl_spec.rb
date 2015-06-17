require 'spec_helper'

describe 'Member Subcon Settlement: When claim_p_settled' do

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
  let(:subcon_entry2) { subcon_job.entries.where(type: AffiliateSettlementEntry.descendants.map(&:name)).order('id asc').last }

  it 'subcon status should be claim_p_settled' do
    expect(job.reload.subcontractor_status_name).to eq :claim_p_settled
  end

  context 'when the subcon confirms the settlement' do
    before do
      with_user(subcon_admin) do
        subcon_entry1.confirm
      end
      job.reload
    end

    context 'when completing the work' do
      before do
        start_the_job subcon_job
        add_bom_to_job subcon_job, cost: 10, price: 100, buyer: subcon, quantity: 1
        complete_the_work subcon_job
        job.reload
      end

      it 'subcon status should be partially_settled' do
        expect(job.reload.subcontractor_status_name).to eq :partially_settled
      end

      context 'when depositing the payment' do
        before do
          with_user(subcon_admin) do
            subcon_entry1.deposit!
          end
          job.reload
        end

        it 'subcon status should be partially_settled' do
          expect(job.subcontractor_status_name).to eq :partially_settled
        end

        context 'when provider initiates another settlement' do
          before do
            with_user(org_admin) do
              settle_with_subcon job, amount: 10, type: 'credit_card'
            end
            job.reload
            subcon_job.reload
          end
          it 'subcon status should be claim_p_settled' do
            expect(job.subcontractor_status_name).to eq :claim_p_settled
          end

          context 'when rejectting the first payment' do
            before do
              with_user(subcon_admin) do
                subcon_entry1.reject!
              end
              job.reload
            end

            it 'subcon status should be claim_p_settled' do
              expect(job.subcontractor_status_name).to eq :claim_p_settled
            end

            context 'when the subcon confirms the second settlement' do
              before do
                with_user(subcon_admin) do
                  subcon_entry2.confirm!
                end
                job.reload
              end

              it 'subcon status should be partially_settled' do
                expect(job.subcontractor_status_name).to eq :partially_settled
              end

              context 'when subcon initiates settlement for the remainder' do
                let(:subcon_entry3) { subcon_job.entries.where(type: AffiliateSettlementEntry.descendants.map(&:name)).order('id asc').last }
                before do
                  subcon_job.reload
                  with_user(subcon_admin) do
                    settle_with_provider subcon_job, amount: 100, type: 'cheque'
                  end
                  job.reload
                end

                it 'subcon status should be claim_settled' do
                  expect(job.subcontractor_status_name).to eq :claim_settled
                end


                context 'when confirming the settlement' do

                  before do
                    with_user(subcon_admin) do
                      subcon_entry3.confirm!
                    end
                    job.reload
                  end

                  it 'subcon status should be settled' do
                    expect(job.subcontractor_status_name).to eq :settled
                  end


                end
              end

            end
          end
        end
      end

    end
  end

  context 'when the subcon settles for another partial amount' do
    before do
      with_user(subcon_admin) do
        settle_with_provider subcon_job, amount: 10, type: 'credit_card'
      end
      job.reload
    end

    it 'should not change the subcon status' do
      expect(job.subcontractor_status_name).to eq :claim_p_settled
    end

    context 'when confirming both the provider and subcon settlement entries' do
      before do
        subcon_entry1.confirm!
        subcon_entry2.confirm!
        job.reload
      end

      it 'should change the subcon status to partially_settled' do
        expect(job.subcontractor_status_name).to eq :partially_settled
      end

    end

  end

  context 'when the subcon confirms the settlement entry' do
    before do
      subcon_entry1.confirm!
    end

    it 'should change he subcon status to partially_settled' do
      expect(job.reload.subcontractor_status_name).to eq :partially_settled
    end

  end

  context 'when the subcon disputes the settlement entry' do
    before do
      subcon_entry1.dispute!
      job.reload
    end

    it 'should change the subcon status to disputed' do
      expect(job.subcontractor_status_name).to eq :disputed
    end
  end

  context 'when competing the job' do
    before do
      start_the_job subcon_job
      add_bom_to_job subcon_job, cost: 10, price: 100, buyer: subcon, quantity: 1
      complete_the_work subcon_job
      job.reload
    end

    it 'should have a balance of 100 (as the bom reimbursement was already paid)' do
      expect(job.organization.account_for(job.subcontractor.becomes(Organization)).balance).to eq Money.new(-10000)
    end

    context 'when settling for the remaining amount' do
      before do
        settle_with_subcon job, amount: 100, type: 'credit_card'
      end

      it 'should change the status as claim_settled' do
        expect(job.subcontractor_status_name).to eq :claim_settled
      end

    end
  end

  context 'before completing the work' do
    context 'when the provider pays the subcon the reminder' do
      before do
        with_user(org_admin) do
          settle_with_subcon job, amount: 100, type: 'credit_card'
        end
        job.reload
      end

      it 'subcon status should remain claim_p_settled' do
        expect(job.subcontractor_status_name).to eq :claim_p_settled
      end

      context 'when the sucbon confirms the first payment' do
        before do
          with_user(subcon_admin) do
            subcon_entry1.confirm!
          end
          job.reload
        end
        it 'provider status should remain claimed_p_settled' do
          expect(job.subcontractor_status_name).to eq :claim_p_settled
        end

      end


      context 'when disputing the payment' do
        before do
          with_user(subcon_admin) do
            subcon_entry1.dispute!
          end
          job.reload
        end

        it 'subcon status should change to disputed' do
          expect(job.subcontractor_status_name).to eq :disputed
        end

        context 'when the subcon confirms both payments' do
          before do
            with_user(subcon_admin) do
              subcon_entry1.confirm!
              subcon_entry2.confirm!
            end
            job.reload
          end

          it 'subcon status should remain partially_settled' do
            expect(job.subcontractor_status_name).to eq :partially_settled
          end

        end


      end

      context 'when competing the work' do
        before do
          start_the_job subcon_job
          add_bom_to_job subcon_job, cost: 10, price: 100, buyer: subcon, quantity: 1
          subcon_job.reload
          complete_the_work subcon_job
          job.reload
        end

        it 'subcon status should change to claim_settled' do
          expect(job.subcontractor_status_name).to eq :claim_settled
        end

      end


    end
  end

end