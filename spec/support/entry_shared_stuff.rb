shared_context 'entry mocks' do
  let(:ticket) {mock_model(Ticket, events: [])}
  let(:account) {mock_model(Account, events: [])}
  let(:agreement) {mock_model(Agreement, events: [])}
  let(:event) {mock_model(Event, events: [])}
  let(:entry) { klass.new(ticket: ticket, account: account, agreement: agreement, event: event, description: 'test') }

end

def event_permitted_for_entry?(state_machine_name, event_name, entry, user = nil)
  params = ActionController::Parameters.new({ accounting_entry: {
      "#{state_machine_name}_event".to_sym => event_name
  } })
  p      = PermittedParams.new(params, user, entry)
  p.service_call.include?("#{state_machine_name}_event")
end
