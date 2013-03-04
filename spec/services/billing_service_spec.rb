require 'spec_helper'

describe AffiliateBillingService do

  let(:billing_service) { AffiliateBillingService.new(FactoryGirl.create(:service_call_completed_event)) }

  subject { billing_service }

  describe "methods" do

    [:execute, :find_affiliate_agreements, :find_customer_agreement].each do |method|
      pending
    end

  end

end