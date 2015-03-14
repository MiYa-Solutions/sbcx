shared_context 'entry event mocks' do

  let(:org) { mock_model(Organization, id: 1, name: 'Test Org1', providers: [], subcontractors: [], subcontrax_member?: true) }
  let(:org2) { mock_model(Organization, id: 2, name: 'Test Org2', providers: [], subcontractors: []) }
  let(:agr) { mock_model(Agreement, id: 1, name: 'Test Agreement', posting_rules: []) }
  let(:ticket) { mock_model(Ticket, id: 1, name: 'Test Ticket', events: Event.none, subcontractor: org2, provider: org, organization: org, provider_agreement: agr, subcon_agreement: agr) }
  let(:ticket2) { mock_model(Ticket, id: 2, name: 'Test Ticket2', events: Event.none, subcontractor: org2, provider: org, organization: org, provider_agreement: agr, subcon_agreement: agr) }
  let(:acc) { mock_model(Account, id: 1, name: 'Test Acc', organization: org, accountable: org2, events: Event.none, entries: AccountingEntry.none) }
  let(:orig_entry) { mock_model(AccountingEntry, id: 1, save: true, amount: Money.new(-1000), matching_entry_id: 2, ticket: ticket2) }
  let(:entry) { mock_model(AccountingEntry, id: 2, save: true, amount: Money.new(1000), matching_entry_id: 1, ticket: ticket) }
  let(:adj_event) { mock_model(AccountAdjustedEvent, id: 2, save: true, matching_entry_id: orig_entry.id) }

end