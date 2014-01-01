# == Schema Information
#
# Table name: boms
#
#  id             :integer          not null, primary key
#  ticket_id      :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  quantity       :decimal(, )
#  material_id    :integer
#  cost_cents     :integer          default(0), not null
#  cost_currency  :string(255)      default("USD"), not null
#  price_cents    :integer          default(0), not null
#  price_currency :string(255)      default("USD"), not null
#  buyer_id       :integer
#  buyer_type     :string(255)
#  creator_id     :integer
#  updater_id     :integer
#

require 'spec_helper'

describe Bom do

  let(:bom) { Bom.new }

  subject { bom }


  it "should have the expected attributes and methods" do
    should respond_to(:total_cost)
    should respond_to(:total_price)
    should respond_to(:ticket)
    should respond_to(:cost)
    should respond_to(:price)
    should respond_to(:quantity)
    should respond_to(:material)
    should respond_to(:material_name)

  end

  describe "validation" do
    before { bom.valid? }

    it { monetize(:price_cents).should be_true }
    it { monetize(:cost_cents).should be_true }
    [:ticket, :cost_cents, :quantity, :price_cents, :material_id].each do |attr|
      it "must have a #{attr}" do
        should validate_presence_of attr
      end
    end

  end

  describe "calculations" do
    before do
      bom.price    = 17.5
      bom.cost     = 3.7
      bom.quantity = 5
    end

    it "total price should = price*quantity" do

      bom.total_price.should == bom.price * bom.quantity

    end
    it "total cost should = cost*quantity" do
      bom.total_cost.should == bom.cost * bom.quantity
    end

  end

  describe "default values" do
    let(:valid_bom) { FactoryGirl.create(:bom) }

    describe "default values are not set when a value is present" do
      before do
        valid_bom.price = valid_bom.material.price + Money.new_with_amount(2)
        valid_bom.cost  = valid_bom.material.cost + Money.new_with_amount(2)
      end

      it "should NOT equal the associated material cost" do
        valid_bom.cost.should_not == valid_bom.material.cost
      end
      it "should NOT equal the associated material price" do
        valid_bom.price.should_not == valid_bom.material.price
      end

    end

  end

  describe "when there is no material with the material_name" do
    let(:bom) { FactoryGirl.build(:bom) }

    it "should create a material if one is not present" do
      bom.material = nil

      expect {
        bom.material_name = "new material"
        bom.cost          = 1000.6
        bom.price         = 34.9
        bom.save
      }.to change { Material.count }.by (1)

    end

  end

  describe 'associations' do
    it do
      should belong_to(:creator)
      should belong_to(:updater)
      should belong_to(:ticket)
      should belong_to(:ticket)
    end
  end


end

# phone: 8664583907
# ext 7866
# fax: 1800 3299373

