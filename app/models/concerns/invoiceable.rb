module Invoiceable
  extend ActiveSupport::Concern
  included do
    def allow_collection
      true
    end

    def subcon_chain_ids
      raise NotImplemented.new('You must implement subcon_chain_ids for the invoiceable')
    end

    def invoiceable_items
      raise NotImplemented.new('You must implement invoiceable_items for the invoiceable')
    end

    def invoice_total
      raise NotImplemented.new('You must implement invoice_total for the invoiceable')
    end
  end
end