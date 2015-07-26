require 'rspec'

describe Statement do

  let(:statement) { Statement.new }

  it 'should validate presence of data' do
    expect(statement).to validate_presence_of :data
  end

  it 'should validate presence of account' do
    expect(statement).to validate_presence_of :account
  end

  it 'should have an association to account' do
     expect(statement).to belong_to :account
  end

  it {expect(statement).to respond_to :notes}
  it {expect(statement).to respond_to :tickets}
  it {expect(statement).to respond_to :balance}
  it {expect(statement).to respond_to :organization}

end