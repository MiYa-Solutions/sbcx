module AccountingMatchers

  class EntryMatcher
    include MoneyRails::ActionViewExtension
    def initialize(entry, params)
      @entry  = entry
      @amount = params[:amount]
      @type   = params[:type]
      @status = params[:status]
    end

    def matches?(actual)
      @errors           = {}
      expected_elements = {
          entry: entry_selector
      }

      expected_values = {}

      unless @amount.nil?
        expected_elements[:amount] = amount_selector
        expected_values[:amount]   = humanized_money_with_symbol(@amount)
      end

      unless @type.nil?
        expected_elements[:type] = type_selector
        expected_values[:type]   = @type
      end

      unless @status.nil?
        expected_elements[:status] = status_selector
        expected_values[:status]   = @status
      end

      expected_elements.each do |key, selector|
        @errors[key] = selector unless actual.has_selector?(selector)
        unless key == :entry # there is no value for entry
          @errors["#{key}_value"] = "expected #{selector}  with value: #{expected_values[key]}" unless actual.has_selector?(selector, text: /#{Regexp.escape(expected_values[key])}/i)
        end
      end
      @errors.empty?

    end

    def failure_message
      message = ""
      message += "accounting entry has no status displayed " if @errors['status']
      message += "the accounting entry status is displayed but the value is wrong" if @errors['status_value']
      message += "accounting entry has no amount displayed " if @errors['amount']
      message += "the accounting entry amount is displayed but the value is wrong" if @errors['amount_value']
      message += "accounting entry has no type displayed " if @errors['type']
      message += "the accounting entry type is displayed but the value is wrong" if @errors['type_value']
      message += "accounting entry has no balance displayed " if @errors['balance']
      message += "the accounting entry balance is displayed but the value is wrong" if @errors['balance_value']
      message += "\n#{@errors.to_yaml}" unless @errors.empty?
      message

    end

    def negative_failure_message
      message = ""
      message += "accounting entry should NOT be displayed" if @errors['entry']
      message += "accounting entry status should NOT be displayed " if @errors['status']
      message += "accounting entry type should NOT be displayed " if @errors['type']
      message += "accounting entry balance should NOT be displayed " if @errors['balance']
      message += "accounting entry amount should NOT be displayed " if @errors['amount']
      message += "\n#{@errors.to_yaml}" unless @errors.empty?
      message
    end

    protected
    def entry_selector
      "tr#accounting_entry_#{@entry.id}"
    end

    def amount_selector
      "td#entry_#{@entry.id}_amount"
    end

    def type_selector
      "td#entry_#{@entry.id}_type"
    end

    def status_selector
      "td#entry_#{@entry.id}_status"
    end


  end

  class AffiliateBalanceMatcher
    include MoneyRails::ActionViewExtension
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
      message = "expected page to show a balance span" if @errors[:balance]
      message = "balance span found but the value is wrong" unless @errors[:balance]
      message += "\n#{@errors.to_yaml}" unless @errors.empty?
      message

    end

    def negative_failure_message
      message = "expected page to NOT show a balance span row with amount = #{humanized_money_with_symbol @balance}"
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
      'span#balance'
    end

  end


  def have_affiliate_balance(balance)
    AffiliateBalanceMatcher.new(balance)
  end
  alias_method :have_balance, :have_affiliate_balance
  def have_customer_balance(balance)
    CustomerBalanceMatcher.new(balance)
  end
  def have_entry(entry, params = {})
    EntryMatcher.new(entry, params)
  end

end