shared_context 'AdjustmentEntry Base Class' do
  include_context 'AccountingEntry Base Class'

  context 'validation' do
    it { expect(entry).to validate_numericality_of(:ticket_ref_id) }
    it { expect(entry).to_not validate_presence_of(:agreement) }

    it 'validates the ticket belongs to the organization' do
      org = mock_model(Organization)
      org2 = mock_model(Organization)
      ticket2 =  FactoryGirl.create(:my_service_call)



    end
  end

  context 'association' do
    it { expect(entry).to belong_to(:ticket) }

  end

  context 'api' do
    it 'sets the ticket to be the one specified in ticket_ref_id' do
      ticket = FactoryGirl.create(:my_service_call)
      entry.ticket_ref_id = ticket.id
      entry.account = ticket.customer_account
      expect(entry.save).to be_true

      expect(entry.ticket).to eq ticket
      # pending
    end

  end

end