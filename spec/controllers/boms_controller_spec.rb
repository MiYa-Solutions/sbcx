require 'spec_helper'

describe BomsController do

  include_context 'transferred job'

  before do

    user.save!
    job.save!
    sign_in(org_admin)
  end

  describe 'POST #create' do

    it 'should not create a bom when the job is transferred' do
      transfer_the_job
      expect do
        post_with(org_admin, :create, service_call_id: job.id, bom: {
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
