require 'rspec'

describe Statement do

  let(:statement) { Statement.new }

  it 'should validate presence of data' do
    expect(statement).to validate_presence_of :data
  end

  it 'should validate presence of statementable' do
    expect(statement).to validate_presence_of :statementable
  end

  it 'should have a polymorphic association to statementable' do
     expect(statement).to belong_to :statementable
  end

  it {expect(statement).to respond_to :items}

end