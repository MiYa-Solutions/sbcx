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

  class SuccessMessageMatcher
    def initialize(message = nil)
      @message = message
    end

    def matches?(actual)
      @errors           = {}
      expected_elements = {
          :alert_div => 'div.alert-success',
      }

      expected_values = {
          :alert_div => @message
      }

      expected_elements.each do |key, selector|
        @errors[key] = selector unless actual.has_selector?(selector)
        if @message.present?
          @errors["#{key}_value"] = "#{selector}  with value: #{expected_values[key]}" unless actual.has_selector?(selector, text: expected_values[key])
        end
      end
      @errors.empty?
    end

    def failure_message
      message = "expected page to success alert" if @errors[:alert_div]
      message = "entry row exists but the value is wrong" unless @errors[:alert_div]
      message += "\n#{@errors.to_yaml}" unless @errors.empty?
      message

    end

    def negative_failure_message
      message = "expected page to NOT show a success alert '#{@message}'"
      message += "\n#{@errors.to_yaml}" unless @errors.empty?
      message
    end

  end
  class EventMatcher
    def initialize(number, text = nil)
      @number = number
      @text = text
    end

    def matches?(actual)
      @errors           = {}
      expected_elements = {
          :number => 'table#event_log_in_service_call tbody tr td'


      }

      expected_values = {
          :number => @number
      }

      unless @text.nil?
        expected_elements[:text] = 'table#event_log_in_service_call tbody tr td'
        expected_values[:text]   = @text
      end


      expected_elements.each do |key, selector|
        @errors[key] = selector unless actual.has_selector?(selector, text: @number)
        if @text.present?
          @errors["#{key}_value"] = "#{selector}  with value: #{expected_values[key]}" unless actual.has_selector?(selector, text: expected_values[key])
        end
      end
      @errors.empty?
    end

    def failure_message
      message = "expected page to have event #{@number}" if @errors[:number]
      message = "event #{@number} exists but the text is wrong" if @errors[:text]
      message += "\n#{@errors.to_yaml}" unless @errors.empty?
      message

    end

    def negative_failure_message
      message = "expected page to NOT show event '#{@number}'"
      message += "\n#{@errors.to_yaml}" unless @errors.empty?
      message
    end

  end

  def have_success_message(message = nil)
    SuccessMessageMatcher.new(message)
  end

  def have_event(number, text = nil)
    EventMatcher.new(number, text)
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