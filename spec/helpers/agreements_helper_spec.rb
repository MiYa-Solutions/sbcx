require 'spec_helper'

describe AgreementsHelper do

  describe "#agreement_options for SubcontractingAgreement" do
    it "should generate provider and subcontractor data attributes" do
      expected_res = [SubcontractingAgreement.name.titleize,
                      SubcontractingAgreement.name.underscore,
                      {
                          "data-organization" => I18n.t('activerecord.attributes.subcontracting_agreement.organization'),
                          "data-counterparty" => I18n.t('activerecord.attributes.subcontracting_agreement.counterparty')
                      }
      ]
      helper.agreement_option(SubcontractingAgreement).should == expected_res
    end
  end
  describe "#agreement_options for SupplierAgreement" do
    it "should generate provider and subcontractor data attributes" do
      expected_res = [SupplierAgreement.name.titleize,
                      SupplierAgreement.name.underscore,
                      {
                          "data-organization" => I18n.t('activerecord.attributes.supplier_agreement.organization'),
                          "data-counterparty" => I18n.t('activerecord.attributes.supplier_agreement.counterparty')
                      }
      ]
      helper.agreement_option(SupplierAgreement).should == expected_res
    end
  end

  context '#agreement_pending_my_action?' do

    let(:agr) { FactoryGirl.build(:subcon_agreement) }
    let(:org_user) { agr.organization.users.first }
    let(:subcon_user) { agr.counterparty.users.first }

    context 'when agreement status is draft' do
      before do
        agr.status  = Agreement::STATUS_DRAFT
        agr.creator = org_user
      end
      it 'should return true when logged in as the creator' do
        helper.stub(:current_user => org_user)
        expect(helper.agreement_pending_my_action?(agr)).to be_true
      end

      it 'should return false when the logged in as the counterparty' do
        helper.stub(:current_user => subcon_user)
        expect(helper.agreement_pending_my_action?(agr)).to be_false
      end
    end
    context 'when agreement status is active' do
      before do
        agr.status = Agreement::STATUS_ACTIVE
      end
      it 'should return true when logged in as the creator' do
        helper.stub(:current_user => org_user)
        expect(helper.agreement_pending_my_action?(agr)).to be_false
      end

      it 'should return false when the logged in as the counterparty' do
        helper.stub(:current_user => subcon_user)
        expect(helper.agreement_pending_my_action?(agr)).to be_false
      end
    end
    context 'when agreement status is pending_org_approval' do
      before do
        agr.status = OrganizationAgreement::STATUS_PENDING_ORG_APPROVAL
      end
      it 'should return true when logged in as the org' do
        helper.stub(:current_user => org_user)
        expect(helper.agreement_pending_my_action?(agr)).to be_true
      end

      it 'should return false when the logged in as the org' do
        helper.stub(:current_user => subcon_user)
        expect(helper.agreement_pending_my_action?(agr)).to be_false
      end
    end
    context 'when agreement status is pending_cparty_approval' do
      before do
        agr.status = OrganizationAgreement::STATUS_PENDING_CPARTY_APPROVAL
      end
      it 'should return true when logged in as the org' do
        helper.stub(:current_user => org_user)
        expect(helper.agreement_pending_my_action?(agr)).to be_false
      end

      it 'should return false when the logged in as the org' do
        helper.stub(:current_user => subcon_user)
        expect(helper.agreement_pending_my_action?(agr)).to be_true
      end
    end
    context 'when agreement status is rejected_by_org' do
      before do
        agr.status = OrganizationAgreement::STATUS_REJECTED_BY_ORG
      end
      it 'should return true when logged in as the org' do
        helper.stub(:current_user => org_user)
        expect(helper.agreement_pending_my_action?(agr)).to be_false
      end

      it 'should return false when the logged in as the org' do
        helper.stub(:current_user => subcon_user)
        expect(helper.agreement_pending_my_action?(agr)).to be_true
      end
    end
    context 'when agreement status is rejected_by_cparty' do
      before do
        agr.status = OrganizationAgreement::STATUS_REJECTED_BY_CPARTY
      end
      it 'should return true when logged in as the org' do
        helper.stub(:current_user => org_user)
        expect(helper.agreement_pending_my_action?(agr)).to be_true
      end

      it 'should return false when the logged in as the org' do
        helper.stub(:current_user => subcon_user)
        expect(helper.agreement_pending_my_action?(agr)).to be_false
      end
    end

    it 'should return true when  '
  end


end
