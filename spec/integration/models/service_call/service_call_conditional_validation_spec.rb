require 'spec_helper'

describe 'Service Call Conditional Validation' do

  let(:org) { FactoryGirl.create(:member_org) }
  let(:org_settings) { org.settings }
  let(:job) { FactoryGirl.build(:my_job, organization: org) }


  context 'when validate validate_job_ext_ref is false' do

    before do
      org_settings.save(validate_job_ext_ref: false)
      job.external_ref = nil
    end
    it 'it should  not validate uniqueness of external_ref' do
      expect(job).to be_valid
    end

    context 'when validate_external_ref_unique is true' do
      before do
        org_settings.save(external_ref_unique: true)
      end

      it 'should allow the creation of a job without a ref' do
        expect(job).to be_valid
      end
    end

    context 'when ext ref  of the job is not unique in the scope of the same organization' do
      let(:job_for_same_org) { FactoryGirl.build(:my_job, organization: org) }
      before do
        job_for_same_org.external_ref = 'ABC123'
        job_for_same_org.save!
        job.external_ref = 'ABC123'
      end

      it 'it should  not validate uniqueness of external_ref' do
        expect(job).to be_valid
      end

      context 'when external_ref_unique is set to true' do
        before do
          org_settings.save(external_ref_unique: true)
        end

        it 'it should  validate uniqueness of external_ref' do
          expect(job).to_not be_valid
        end

      end


    end

  end

  context 'when validate validate_job_ext_ref is true' do
    before do
      org_settings.save(validate_job_ext_ref: true)
    end

    context 'when ext ref for the job is not present' do
      before do
        job.external_ref = nil
      end

      it 'it should validate presence of external_ref' do
        expect(job).to_not be_valid
      end
    end

    context 'when ext ref  of the job is not unique in the scope of the same organization' do
      let(:job_for_same_org) { FactoryGirl.build(:my_job, organization: org) }
      before do
        job_for_same_org.external_ref = 'ABC123'
        job_for_same_org.save!
        job.external_ref = 'ABC123'
      end

      it 'should  not validate uniqueness of external_ref' do
        expect(job).to be_valid
      end

      context 'when external_ref_unique is set to true' do
        before do
          org_settings.save(external_ref_unique: true)
        end

        it 'it should  validate uniqueness of external_ref' do
          expect(job).to_not be_valid
        end

      end

    end

    context 'when ext ref  of the job is not unique across all orgs' do
      let(:job_for_same_org) { FactoryGirl.build(:my_job) }
      before do
        job_for_same_org.external_ref = 'ABC123'
        job_for_same_org.save!
        job.external_ref = 'ABC123'
      end

      it 'it should  not validate uniqueness of external_ref' do
        expect(job).to be_valid
      end
    end

    context 'when external_ref_unique is set to true' do
      before do
        org_settings.save(external_ref_unique: true)
      end

      context 'when there is no external ref set' do

        before do
          job.external_ref = nil
        end

        it 'it should  validate uniqueness of external_ref' do
          expect(job).to_not be_valid
        end

      end

    end

  end
end