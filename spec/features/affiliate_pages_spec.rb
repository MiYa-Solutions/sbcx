require 'spec_helper'
require_relative '../../spec/features/features_shared_stuff'

describe 'Affiliate Pages' do

  include_context 'successful sign up'

  context 'successful affiliate creation' do
    before do
      visit new_affiliate_path
    end

    it 'should create the affiliate successfully' do
      pending
    end
  end

  pending 'affiliate test implementation'

end