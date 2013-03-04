module Matchers
  class AccountingEntryMatcher
    def initialize(entry, amount)
      @entry  = entry
      @amount = amount
    end

    def matches?(actual)
      @errors           = {}
      expected_elements = {
          :entry_row => "tr#accounting_entry_#{@entry.id} td",
      }

      expected_values = {
          :entry_row => "#{humanized_money_with_symbol @amount}"
      }

      expected_elements.each do |key, selector|
        @errors[key] = selector unless actual.has_selector?(selector)
        @errors["#{key}_value"] = "#{selector}  with value: #{expected_values[key]}" unless actual.has_selector?(selector, text: expected_values[key])
      end
      @errors.empty?
    end

    def failure_message
      message = "expected page to have an entry row" if @errors[:entry_row]
      message = "entry row exists but the value is wrong" unless @errors[:entry_row]
      message += "\n#{@errors.to_yaml}" unless @errors.empty?
      message

    end

    def negative_failure_message
      message = "expected page to NOT have an entry row with amount = #{humanized_money_with_symbol @amount}"
      message += "\n#{@errors.to_yaml}" unless @errors.empty?
      message
    end
  end

  class AffiliateBalanceMatcher
    def initialize(balance)
      @balance = balance
    end

    def matches?(actual)
      @errors           = {}
      expected_elements = {
          :balance => get_balance_selector,
      }

      expected_values = {
          :balance => "#{humanized_money_with_symbol @balance}"
      }

      expected_elements.each do |key, selector|
        @errors[key] = selector unless actual.has_selector?(selector)
        @errors["#{key}_value"] = "#{selector}  with value: #{expected_values[key]}" unless actual.has_selector?(selector, text: expected_values[key])
      end
      @errors.empty?

    end

    def failure_message
      message = "expected page to have an affiliate balance span" if @errors[:balance]
      message = "balance span found but the value is wrong" unless @errors[:balance]
      message += "\n#{@errors.to_yaml}" unless @errors.empty?
      message

    end

    def negative_failure_message
      message = "expected page to NOT have an balance span row with amount = #{humanized_money_with_symbol @balance}"
      message += "\n#{@errors.to_yaml}" unless @errors.empty?
      message
    end

    protected
    def get_balance_selector
      AFF_SPAN_BALANCE
    end

  end

  class CustomerBalanceMatcher < AffiliateBalanceMatcher
    protected
    def get_balance_selector
      'span#customer_balance'
    end

  end

  def have_entry(entry, amount)
    AccountingEntryMatcher.new(entry, amount)
  end

  def have_affiliate_balance(balance)
    AffiliateBalanceMatcher.new(balance)
  end
  def have_customer_balance(balance)
    CustomerBalanceMatcher.new(balance)
  end

end

#RSpec::Matchers.define :have_entry_for do |entry, rule|
#  match do |actual|
#    @errors           = {}
#    expected_elements = {
#        :entry_row    => "tr#accounting_enry_#{entry.id} td",
#        #:entry_amount => "#{humanized_money_with_symbol -(entry.ticket.total_profit * (rule.rate / 100.0))}"
#    }
#
#    expected_elements.each do |key, selector|
#      puts have_selector(selector).inspect
#      @errors[key] = selector unless actual.has_selector?(selector)
#    end
#    @errors.empty?
#
#    #matching = context.all(selector)
#    #@matched = matching.size
#    #@matched == expected_match_count
#  end
#
#  failure_message_for_should do
#    "STAM for SHOULD"
#  end
#
#  failure_message_for_should_not do
#    "STAM for SHOULD NOT"
#  end
#end