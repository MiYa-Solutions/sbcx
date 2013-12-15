require 'spec_helper'

describe AgreementUpdateEvent do
  # need to create a shared context for agreement testing
  let(:agr_event) {}

  # should be invoked only after submission, therefore changes should accumulate
  # new model: AgreementChanges
  # AgreementChangeSubmission event will collect all the un-submitted changes to create a description
  # Changes will be classified: agreement properties, and rule properties

  # USING PAPER TRAIL
  # Sumission Event Should simply create a description, highlighting the changes
  # data model
  # model: Change
  # # Table changes
  # columns:
  # * change:hstore - a hash in the form of {column_name: [before_val, after_val]}
  # * status:integer
  # * changeable_id - polymorphic
  # * changeable_type


  it 'do somthing' do
    true.should == false
  end
end