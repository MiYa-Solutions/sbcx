module CustomersHelper
  include ApplicationHelper

  def customer_events(customer = @customer)
    CustomerEventsFormsRenderer.new(customer, self).render
  end


  class CustomerEventsFormsRenderer

    def initialize(obj, view)
      @obj  = obj
      @view = view
    end

    def render
      rendered = []

      available_events.each do |event|
        # don't render the same form twice
        unless rendered.include? view_map[event]
          @view.concat(@view.render form_view_home_path + view_map[event], customer: @obj)
          rendered << view_map[event]
        end
      end
      ''

    end


    private

    def form_view_home_path
      'customers/action_forms/status_form/'
    end

    def view_map
      {
          disable:  'disable',
          activate: 'activate'
      }
    end

    def available_events
      @obj.status_events
    end

  end

end
