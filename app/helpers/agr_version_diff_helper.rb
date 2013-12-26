module AgrVersionDiffHelper

  def agr_diff_attrs
    { name:          :name,
      description:   :description,
      status:        :human_status_name,
      starts_at:     :starts_at,
      ends_at:       :ends_at,
      payment_terms: :payment_terms
    }
  end


  def agreement_html_diff
    #each key in the hash is the attr name and each value is the method to call to get it human value
    res = ""
    agr_diff_attrs.each do |attr, method|
      res = res + (render 'agreements/agreement_diff/diff_table_row',
                          attr_name: Agreement.human_attribute_name(attr),
                          v1:        @v1.send(method),
                          v2:        @v2.send(method))
    end
    res
  end

end
