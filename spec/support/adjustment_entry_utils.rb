AE_BTN_ADD_NEW_ENTRY   = 'add_new_entry'
AE_BTN_ADD_ENTRY       = 'add_entry'
AE_INPUT_AMOUNT        = 'accounting_entry_amount'
AE_INPUT_DESCRIPTION   = 'accounting_entry_description'
AE_INPUT_TICKET        = 'accounting_entry_ticket_ref_id'
AE_BTN_ACCEPT          = 'adjustment_entry_accept_btn'
AE_BTN_REJECT          = 'adjustment_entry_reject_btn'
AE_BTN_CANCEL          = 'adjustment_entry_cancel_btn'
AE_ADJUSTED_NOTIF_LINK = 'table.table tbody tr.account_adjusted_notification:last-child td:nth-child(2) a'
AE_ACCEPTED_NOTIF_LINK = 'table.table tbody tr.acc_adj_accepted_notification:last-child td:nth-child(2) a'
AE_REJECTED_NOTIF_LINK = 'table.table tbody tr.acc_adj_rejected_notification:last-child td:nth-child(2) a'
AE_CANCELED_NOTIF_LINK = 'table.table tbody tr.acc_adj_canceled_notification:last-child td:nth-child(2) a'

AE_STATUS = 'span#accounting_entry_status'

def create_adj_entry(acc, amount, ticket)
  visit accounting_entries_path

  select2_select acc.accountable.name, from: 'account'

  #select2 acc.accountable.name, xpath: "//*[@id='s2id_account']", search: true
  click_button AE_BTN_ADD_NEW_ENTRY
  fill_in AE_INPUT_AMOUNT, with: amount
  fill_in AE_INPUT_DESCRIPTION, with: 'test description'
  fill_in AE_INPUT_TICKET, with: ticket.ref_id
  click_button AE_BTN_ADD_ENTRY
  page.has_selector?('li.add_button span.alert-success')
end

def create_adj_entry_for_ticket(acc, amount, ticket)

  entry = MyAdjEntry.new(account: acc, amount: amount, description: "Test", ticket_ref_id: ticket.ref_id)
  acc.entries << entry

  entry
end
