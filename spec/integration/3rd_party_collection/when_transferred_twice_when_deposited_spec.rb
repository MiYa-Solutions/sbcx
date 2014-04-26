require 'spec_helper'

describe '3rd Party Collection' do

  include_context 'brokered job'

  before do
    accept_the_job subcon_job
    start_the_job subcon_job
    add_bom_to_job subcon_job, cost: 100, price: 1000, quantity: 1
    complete_the_work subcon_job
  end

  context 'when in deposited state' do
    pending 'when provider collects fully'
    pending 'when provider collects partially'
    pending 'when broker collects fully'
    pending 'when broker collects partially'
    pending 'when subcon collects fully'
    pending 'when subcon collects partially'
  end

end