module ServiceCallMatchers
  class StatusMatcher
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
        @errors[key] = selector unless actual.has_selector?(selector)
        @errors["#{key}_value"] = "expected #{selector}  with value: #{expected_values[key]}" unless actual.has_selector?(selector, text: /#{Regexp.escape(expected_values[key])}/i)
      end
      @errors.empty?

    end

    def failure_message
      message = "expected page to have show a job #{status_name} of " if @errors[:status]
      message = "the job #{status_name} is displayed but the value is wrong" unless @errors[:status]
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
      JOB_STATUS
    end

    def status_name
      'status'
    end


  end
  class SubconStatusMatcher < StatusMatcher

    def status_selector
      JOB_SUBCONTRACTOR_STATUS
    end

    def status_name
      'subcontractor status'
    end

  end
  class ProviderStatusMatcher < StatusMatcher

    def status_selector
      JOB_PROVIDER_STATUS
    end

    def status_name
      'provider status'
    end

  end
  class WorkStatusMatcher < StatusMatcher

    def status_selector
      JOB_WORK_STATUS
    end

    def status_name
      'work status'
    end

  end
  class BillingStatusMatcher < StatusMatcher

    def status_selector
      JOB_BILLING_STATUS
    end

    def status_name
      'billing status'
    end

  end

  def have_status(status)
    StatusMatcher.new(status)
  end

  def have_subcon_status(status)
    SubconStatusMatcher.new(status)
  end

  def have_provider_status(status)
    ProviderStatusMatcher.new(status)
  end

  def have_work_status(status)
    WorkStatusMatcher.new(status)
  end

  def have_billing_status(status)
    BillingStatusMatcher.new(status)
  end
end