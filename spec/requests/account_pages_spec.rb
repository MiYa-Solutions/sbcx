require 'spec_helper'

describe "Account Pages" do

  # todo create all entry types per the below
  # todo create all payment types
  # todo show payment type in the payment form
  # todo add beneficiary for cheque payment upon completion
  # todo complete the profit split rule
  # todo create the fixed price rule
  # todo create correction ability using account entries controller
  # todo add collected_by to the payment event
  # todo add a proposal ticket type
  # todo complete the spec below


  describe "not transferred service call" do
    describe "completed" do

    end

  end

  describe "transferred service call" do
    describe "with profit share" do
      describe "when completed" do
        it "customer's account should show service call charge entry"
        it "provider's view should show a payment to subcon entry (withdrawal)"
        it "subcontractor's view should show a payment from provider entry (income)"
        it "technician's view should show a profit share entry (income)"

        describe "when paid" do
          describe "with cash payment" do
            it "customer's account should show cash payment entry"
            it "customer's account balance should be zero"
            it "provider's account should show cash collection from subcontractor with a pending status (income)"
            it "subcontractor's account should show cash collection to provider with pending status (withdrawal)"
            it "technician's account should show cash collection to employer with pending status (withdrawal)"
          end
          describe "with credit card payment" do
            it "should update provider's account"
            it "should update subcontractor's account"
            it "should update technician's account"
          end
          describe "with cheque payment" do
            describe "where the provider is the beneficiary" do
              describe "when collected by the technician" do
                it "customer's account should show a service call payment entry"
                it "provider's account should show a pending cheque collection by subcon entry"
                it "subcontractor's account should show pending cheque collection for prov entry"
                it "should update technician's account should show pending withdrawal"

                describe "when the cheque is marked as deposited by the subcontractor" do
                  it "provider's account should show the entry as deposited"
                  it "provider's account should now have the amount type as withdrawal"
                  it "subcontractor's account should show the entry as deposited"
                  it "subcontractor's account should now have the amount type as income"
                  it "technician's account should show the entry as deposited"
                  it "technician's account should now have the amount type as income"

                  describe "when provider marks the transaction as cleared" do
                    it "provider's account should show the entry as cleared"
                    it "subcontractor's account should show the entry as cleared"
                    it "technician's account should show the entry as cleared"
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

