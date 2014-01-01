require 'spec_helper'
require_relative '../../lib/invoice'

describe Invoice do
  let(:job) { mock_model(ServiceCall) }
  let(:invoice) { Invoice.new(job) }

  it 'should have a generate_pdf method' do
    expect(invoice).to respond_to(:generate_pdf)
  end

end