require 'hstore_setup_methods'
module HstoreAmount
  def self.included(base)
    base.extend HstoreSetupMethods
    base.setup_hstore_attr 'amount_cents'
    base.setup_hstore_attr 'amount_currency'
    base.monetize :amount_cents
  end

end