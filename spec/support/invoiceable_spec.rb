require 'spec_helper'

shared_context 'Invoiceable' do

  it { should respond_to :subcon_chain_ids }
  it { should respond_to :allow_collection }
  it { should respond_to :invoices }
  it { should respond_to :invoiceable_items }
  it { should have_many :invoices }
end