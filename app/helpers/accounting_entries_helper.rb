module AccountingEntriesHelper
  def account_options
    aff_key = Affiliate.model_name.human.pluralize
    cus_key =  Customer.model_name.human.pluralize
    options = { aff_key => [], cus_key => [] }
    @accounts.each do |acc|
      case acc.accountable_type
        when Organization.name
          options[aff_key] << [acc.accountable.name, acc.id, {"data-balance" => humanized_money_with_symbol(acc.balance)}]
        when Customer.name
          options[cus_key] << [acc.accountable.name, acc.id, {"data-balance" => humanized_money_with_symbol(acc.balance)}]
        else
          raise "Unexpected accountable type "

      end
    end
    options
  end
end
