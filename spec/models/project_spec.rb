require 'spec_helper'

describe Project do

  subject { Project.new }
  include_context 'Invoiceable'

  it { should have_db_column :name }
  it { should have_db_column :description }
  it { should have_db_column :status }
  it { should have_many :tickets }
  it { should have_many(:invoices) }
  it { should have_many(:events) }
  it { should belong_to(:organization) }
  it { should belong_to(:provider) }
  it { should belong_to(:provider_agreement) }
  it { should belong_to(:customer) }
  it { should respond_to(:contractors) }
  it { should respond_to(:customers) }
  it { should respond_to(:subcontractors) }
  it { should respond_to(:work_done?) }

  describe 'validation' do
    it { should validate_uniqueness_of :name }
  end
end
