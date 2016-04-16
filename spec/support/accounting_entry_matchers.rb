module AccountingEntryMatchers
  class EntryStatusMatcher
    def initialize(status)
      @status = status
    end

    def matches?(actual)
      @errors           = {}
      expected_elements = {
          :status => status_selector,
      }

      expected_values = {
          :status => @status
      }

      expected_elements.each do |key, selector|
        if actual.has_selector?(selector, visible: :all)
          actual_text = actual.find(selector).text
          @errors["#{key}_value"] = "expected #{selector}  with value: #{expected_values[key]}, but received: #{actual_text}" unless actual.has_selector?(selector, text: /#{Regexp.escape(expected_values[key])}/i, visible: :all)
        else
          @errors[key] = selector
        end
      end

      @errors.empty?

    end

    def failure_message
      message = "expected page to show a #{status_name} but none was found" if @errors[:status]
      message = "the #{status_name} is displayed but the value is wrong " unless @errors[:status]
      message += "\n#{@errors.to_yaml}" unless @errors.empty?
      message

    end

    def negative_failure_message
      message = "expected page to NOT show a #{status_name} of  '#{@status}'"
      message += "\n#{@errors.to_yaml}" unless @errors.empty?
      message
    end

    protected
    def status_selector
      AE_STATUS
    end

    def status_name
      'entry status'
    end


  end

  class AccountSynchStatusMatcher < EntryStatusMatcher

    def status_selector
      AFF_SPAN_SYNCH_STATUS
    end

    def status_name
      'synch status'
    end


  end

  def have_entry_status(status)
    EntryStatusMatcher.new(status)
  end

  def have_synch_status(status)
    AccountSynchStatusMatcher.new(status)
  end

end