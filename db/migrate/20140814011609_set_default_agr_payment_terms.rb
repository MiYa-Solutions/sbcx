class SetDefaultAgrPaymentTerms < ActiveRecord::Migration
  def up
    OrganizationAgreement.all.each do |agr|
      if agr.payment_terms.nil?
        agr.update_attribute(:payment_terms, 'net_30')
      end
    end

  end


  def down
  end

end
