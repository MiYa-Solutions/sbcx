require 'spec_helper'

describe "Boms" do
  let(:bom) { Bom.new }
  subject { bom }

  it "should have the expected attributes and methods" do
    should respond_to(:ticket_id)
    should respond_to(:quantity)
    should respond_to(:material_id)
    should respond_to(:cost)
    should respond_to(:price)
    should respond_to(:buyer)
  end

  describe "validation" do
    before { bom.valid? }
    [:ticket, :quantity, :material].each do |attr|
      it "must have a #{attr}" do
        bom.errors[attr].should_not be_empty
      end
    end


    it "price should type of Money" do
      bom.price.should be_a Money
    end
    it "cost should type of Money" do
      bom.cost.should be_a Money
    end

    describe "buyer has to be be one of provider, subcontractor or technician" do
      let(:valid_bom) { FactoryGirl.create(:bom) }
      describe "when the buyer is invalid" do

        it " when other user the buyer should have an error associated" do
          other_user      = FactoryGirl.create(:org_admin)
          valid_bom.buyer = other_user
          valid_bom.valid?
          valid_bom.errors[:buyer].should_not be_empty
        end
        it " when other organization the buyer should have an error associated" do
          other_org       = FactoryGirl.create(:org_admin).organization
          valid_bom.buyer = other_org
          valid_bom.valid?
          valid_bom.errors[:buyer].should_not be_empty
        end

      end
      describe "when the buyer is the provider" do

        before do
          valid_bom.buyer = valid_bom.ticket.provider
          valid_bom.valid?
        end

        it "buyer should be valid and NOT have an error associated" do
          valid_bom.errors[:buyer].should be_empty
        end

      end
      describe "when the buyer is the subcontractor" do

        before do
          valid_bom.buyer = valid_bom.ticket.subcontractor
          valid_bom.valid?
        end

        it "buyer should be valid and NOT have an error associated" do
          valid_bom.errors[:buyer].should be_empty
        end

      end
      describe "when the buyer is the technician" do

        before do
          valid_bom.buyer = valid_bom.ticket.technician
          valid_bom.valid?
        end

        it "buyer should be valid and NOT have an error associated" do
          valid_bom.errors[:buyer].should be_empty
        end

      end


    end

  end

  describe "default values" do
    let(:bom) { FactoryGirl.create(:bom) }

    # attributes that have default values
    [:buyer, :cost, :price].each do |attr|
      it "#{attr} must have a default value" do
        bom.send("#{attr}=", nil)
        bom.valid?.should be_true
        bom.send(attr).should_not be_nil
      end

    end

  end

  describe "associations" do
    it { should belong_to(:ticket) }
    it { should belong_to(:material) }
    it { should belong_to(:buyer) }
  end

end
