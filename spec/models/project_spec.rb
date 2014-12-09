require 'spec_helper'

describe Project do

  subject { Project.new }

  it { should have_db_column :name }
  it { should have_db_column :description }
  it { should have_db_column :status }
  it { should have_many :tickets }
  it { should validate_uniqueness_of :name }
  it { should have_many(:invoices) }
  it { should belong_to(:organization) }
end
