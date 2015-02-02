shared_context 'AccountingEntry Base Class' do
  subject { entry }

  it "should have the expected attributes and methods" do
    should respond_to(:account_id)
    should respond_to(:event_id)
    should respond_to(:status)
    should respond_to(:amount_cents)
    should respond_to(:amount_currency)
    should respond_to(:ticket_id)
    should respond_to(:type)
    should respond_to(:description)
    should respond_to(:notes)
  end

  describe "validation" do
    it { expect(entry).to validate_presence_of(:description) }
    it { expect(entry).to validate_presence_of(:ticket) }
    it { expect(entry).to validate_presence_of(:event) }
    it { expect(entry).to validate_presence_of(:type) }
    it { expect(entry).to validate_presence_of(:account) }
    it { should validate_presence_of(:status) }
    it "amount should be Money object" do
      entry.amount.should be_a Money
    end

  end

  describe 'associations' do
    it { should belong_to(:account) }
    it { should belong_to(:ticket) }
    it { should belong_to(:agreement) }
    it { should belong_to(:matching_entry) }
  end

end
