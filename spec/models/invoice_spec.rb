require 'spec_helper'

describe Invoice do

  subject { Invoice.new }

  it 'should have a generate_pdf method' do
    should respond_to(:generate_pdf)
  end

  it { should belong_to(:organization) }
  it { should belong_to(:ticket) }
  it { should belong_to(:account) }
  it { should have_many(:invoice_items) }
  it { should have_db_column(:notes) }
  it { should have_db_column(:total_cents) }
  it { should have_db_column(:total_currency) }

  it { monetize(:total_cents).should be_true }


  # validations

  it { should validate_presence_of :organization }
  it { should validate_presence_of :ticket }
  it { should validate_presence_of :account }
  pending 'good way to test the generated pdf'

end