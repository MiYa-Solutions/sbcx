# == Schema Information
#
# Table name: materials
#
#  id              :integer          not null, primary key
#  organization_id :integer
#  supplier_id     :integer
#  name            :string(255)
#  description     :text
#  creator_id      :integer
#  updater_id      :integer
#  status          :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  cost_cents      :integer          default(0), not null
#  cost_currency   :string(255)      default("USD"), not null
#  price_cents     :integer          default(0), not null
#  price_currency  :string(255)      default("USD"), not null
#  deleted_at      :datetime
#

require 'spec_helper'

describe Material do
  let!(:material) { Material.new }

  subject { material }

  it "should have the expected attributes and methods" do
    should respond_to(:cost)
    should respond_to(:price)
    should respond_to(:supplier)
    should respond_to(:supplier_name)
    should respond_to(:organization)
    should respond_to(:status)
    should respond_to(:name)
    should respond_to(:description)
    should respond_to(:updater)
    should respond_to(:creator)
    should respond_to(:boms)

  end

  describe "validation" do
    #before { material.valid? }
    [:supplier, :status, :organization, :name].each do |attr|
      it "must have a #{attr}" do
        expect(material).to validate_presence_of attr
      end
    end

    context 'verify money attributes' do
      [:cost, :price].each do |money_attr|
        it "#{money_attr} should be of type Money" do
          expect(material).to monetize(money_attr)
        end
      end
    end


    it "status should initialize to available" do
      material.status.should == Material::STATUS_AVAILABLE
    end

  end

end
