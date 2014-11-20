class FixPaymentTerms < ActiveRecord::Migration
  def up
    Agreement.where('payment_terms NOT in (?)', Agreement.payment_options.keys.map(&:to_s)).each do |agr|
      agr.update_attribute(:payment_terms, Agreement.default_payment_term)
    end
  end

  def down
  end
end
