# == Schema Information
#
# Table name: agreements
#
#  id               :integer         not null, primary key
#  name             :string(255)
#  subcontractor_id :integer
#  provider_id      :integer
#  description      :text
#  created_at       :datetime        not null
#  updated_at       :datetime        not null
#

require 'spec_helper'

describe Agreement do

  let(:new_agreement) { Agreement.new }

  subject { new_agreement }

  it "should have the expected attributes and methods" do
    should respond_to(:provider)
    should respond_to(:subcontractor)
    should respond_to(:description)
    should respond_to(:status)
  end

  describe "validation" do
    [:provider, :subcontractor].each do |attr|
      it "must have a #{attr}" do
        new_agreement.errors[attr].should_not be_nil
      end
    end
  end

end
