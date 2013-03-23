module AccountingMatchers
  class EntryMatcher
    def initialize(entry, params)
      @entry  = entry
      @amount = params[:amount]
      @type   = params[:type]
      @status = params[:status]
    end

    def matches?(actual)
      @errors           = {}
      expected_elements = {
          :entry => entry_selector,
      }

      expected_values = {}

      unless @amount.nil?
        expected_elements.merge amount: amount_selector
        expected_values.merge amount: @amount
      end

      unless @type.nil?
        expected_elements.merge type: type_selector
        expected_values.merge type: @type
      end

      unless @status.nil?
        expected_elements.merge status: status_selector
        expected_values.merge status: @status
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
      message = "accounting entry has no status displayed " if @errors['status']
      message = "the accounting entry status is displayed but the value is wrong" if @errors['status_value']
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
      message = "accounting entry should NOT be displayed" if @errors['entry']
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

  def have_entry(entry, params = {})
    EntryMatcher.new(entry, params)
  end

end