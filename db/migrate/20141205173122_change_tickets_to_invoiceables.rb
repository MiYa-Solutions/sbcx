class ChangeTicketsToInvoiceables < ActiveRecord::Migration
  def change
    rename_column :invoices, :ticket_id, :invoiceable_id
    add_column :invoices, :invoiceable_type, :string
    Invoice.all.each do |i|
      i.update_attribute :invoiceable_type, 'Ticket'
    end

    add_index :invoices, [:invoiceable_id, :invoiceable_type]
  end

end
