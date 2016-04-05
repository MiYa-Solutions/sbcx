class InvoiceItem < ActiveRecord::Base

  belongs_to :invoice
  belongs_to :invoiceable, polymorphic: true
  belongs_to :bom,
             class_name:  'Bom',
             foreign_key: 'invoiceable_id'
  belongs_to :entry,
             class_name:  'AccountingEntry',
             foreign_key: 'invoiceable_id'
end