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

end
