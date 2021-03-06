module AccountingEntriesHelper
  def account_options
    aff_key = Affiliate.model_name.human.pluralize
    cus_key = Customer.model_name.human.pluralize
    options = { aff_key => [], cus_key => [] }
    @accounts.each do |acc|
      case acc.accountable_type
        when Organization.name
          options[aff_key] << [acc.accountable.name, acc.id, { "data-balance" => humanized_money_with_symbol(acc.balance) }]
        when Customer.name
          options[cus_key] << [acc.accountable.name, acc.id, { "data-balance" => humanized_money_with_symbol(acc.balance) }]
        else
          raise "Unexpected accountable type "

      end
    end
    options
  end

  def adjustment_entry_actions(entry, klass = '')
    content_tag_for :ul, entry, class: "adj_entry_events unstyled" do
      entry.allowed_status_events.each do |event|
        concat(content_tag :li, render("accounting_entries/action_forms/#{event}_form", entry: entry, css_class: klass))
      end
    end

  end


end
