require 'spec_helper'

describe Affiliate do
  let(:aff) { FactoryGirl.build(:affiliate) }

  it 'should not have industry as mandatory' do
    expect(aff).to_not validate_presence_of(:industry)
  end

  pending '#invited(org)'
  pending '#invites_by_org(org)'

end