require 'spec_helper'

describe CustomEvent do

  let(:custom_event) { CustomEvent.new }

  it 'should be a subclass of Event' do
    expect(custom_event).to be_kind_of(Event)
  end
  it 'should validate reference_num to be between 100 and 100000' do
    custom_event.reference_id = 10
    expect(custom_event).to be_invalid
    expect(custom_event.errors[:reference_id]).to include('must be greater than or equal to 100')

    custom_event.reference_id = 100001
    expect(custom_event).to be_invalid
    expect(custom_event.errors[:reference_id]).to include('must be less than or equal to 100000')

  end

  it 'should validate the presence of the name' do
    expect(custom_event).to validate_presence_of(:name)
  end

  it '#init should set a default reference_id and no description' do
    custom_event.init
    expect(custom_event.reference_id).to eq 100
    expect(custom_event.description).to eq ''
  end
end