require 'spec_helper'

describe Invoice do
  let(:job) { FactoryGirl.build(:my_job) }
  let(:invoice) { Invoice.new(job) }

  it 'should have a generate_pdf method' do
    MyServiceCall.stub(find_by_ref_id: job)
    expect(invoice).to respond_to(:generate_pdf)
  end

  pending 'good way to test the generated pdf'

end