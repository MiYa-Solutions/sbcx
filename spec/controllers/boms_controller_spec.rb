require 'spec_helper'

describe BomsController do

  let(:job) { FactoryGirl.create(:my_service_call) }
  let(:user) { User.my_admins(job.organization.id).first }

  before do
    sign_in(user)
  end

  describe 'POST #create' do

    it 'should not create a bom when the job is transferred' do
      job.transfer!
      expect do
        post_with(user, :create, service_call_id: job.id ,bom: {
            material_name: "lock",
            quantity:      "1",
            price:         "100",
            cost:          "10",
            buyer:         "",
            buyer_type:    "" }
        )

      end.to_not change(Bom, :count)
    end
  end
end
