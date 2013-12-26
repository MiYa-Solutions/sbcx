require 'spec_helper'

describe AgrVersionDiffService do
  #  id                :integer          not null, primary key
  #  name              :string(255)
  #  counterparty_id   :integer
  #  organization_id   :integer
  #  description       :text
  #  created_at        :datetime         not null
  #  updated_at        :datetime         not null
  #  status            :integer
  #  counterparty_type :string(255)
  #  type              :string(255)
  #  creator_id        :integer
  #  updater_id        :integer
  #  starts_at         :datetime
  #  ends_at           :datetime
  #  payment_terms     :string(255)


  let(:agr_v1) { mock_model(Agreement, id: 1, name: 'Agr V1',) }
  let(:agr_v1_ver) { mock_model(PaperTrail::Version, id: 1) }
  let(:agr_v2) { mock_model(Agreement) }
  let(:agr_v2_ver) { mock_model(PaperTrail::Version, id: 2) }

  let(:diff_service) { AgrVersionDiffService.new(agr_v1, agr_v2) }

  it 'should have a html description method' do
    expect(diff_service).to respond_to(:html_description)
  end

  context '#html_description' do

  end
end