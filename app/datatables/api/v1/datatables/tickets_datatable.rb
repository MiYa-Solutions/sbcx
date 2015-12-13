class Api::V1::Datatables::TicketsDatatable < Api::V1::Datatables::Datatable
  def table_row(ticket)

    {
        id:                   ticket.id,
        ref_id:               ticket.ref_id,
        text:                 ticket.name,
        status:               ticket.status_name,
        human_status:         ticket.human_status_name,
        human_work_status:    ticket.human_work_status_name,
        work_status:          ticket.work_status_name,
        human_billing_status: ticket.human_billing_status_name,
        billing_status:       ticket.billing_status_name
    }

  end

  protected

  def table_name
    'tickets'
  end

  def custom_filters(scope)
    new_scope = scope
    new_scope = Api::V1::Filters::CustomerFilter.new(new_scope, params).scope
    new_scope = Api::V1::Filters::StatusFilter.new(new_scope, params).scope
    new_scope = Api::V1::Filters::ProviderFilter.new(new_scope, params).scope
    new_scope = Api::V1::Filters::SubconFilter.new(new_scope, params).scope
    new_scope = Api::V1::Filters::CreatedAtFilter.new(new_scope, params).scope


    # new_scope = new_scope.merge(created_date_filter)
    # new_scope = new_scope.merge(created_date_filter)
    # new_scope = new_scope.merge(affiliate_filter)
    # new_scope = new_scope.merge(account_filter)
    # new_scope = new_scope.merge(billing_status_filter)
    # new_scope = new_scope.merge(billing_status_filter)
    # new_scope = new_scope.merge(work_status_filter)
    # new_scope = new_scope.merge(projct_status_filter)
    # new_scope
    new_scope
  end

  def data
    case params[:table_type]
      when 'open_jobs'
        records.map do |ticket|
          open_jobs_row(ticket)
        end

      when 'new_jobs'
        records.map do |ticket|
          new_jobs_row(ticket)
        end

      when 'new_transferred_jobs'
        records.map do |ticket|
          new_jobs_row(ticket)
        end

      when 'in_progress_jobs'
        records.map do |ticket|
          in_progress_jobs_row(ticket)
        end

      when 'transferred_in_progress_jobs'
        records.map do |ticket|
          in_progress_jobs_row(ticket)
        end

      when 'done_jobs'
        records.map do |ticket|
          done_jobs_row(ticket)
        end

      when 'done_transferred_jobs'
        records.map do |ticket|
          done_jobs_row(ticket)
        end

      when 'customer_active_jobs'
        records.map do |ticket|
          customer_active_jobs_row(ticket)
        end

      when 'customer_overdue_jobs'
        records.map do |ticket|
          customer_overdue_jobs_row(ticket)
        end

      when 'all_jobs'
        records.map do |ticket|
          all_jobs_row(ticket)
        end

      else

        records.map do |ticket|
          table_row(ticket)
        end
    end
  end

  private

  def open_jobs_row(ticket)

    {
        ref_id:            ticket.ref_id,
        text:              ticket.name,
        human_name:        link_to(ticket.name, ticket),
        status:            ticket.status_name,
        human_status:      ticket.human_status_name,
        human_work_status: ticket.human_work_status_name,
        work_status:       ticket.work_status_name,
    }

  end

  def new_jobs_row(ticket)

    {
        ref_id:            ticket.ref_id,
        text:              ticket.name,
        human_name:        link_to(ticket.name, ticket),
        customer:          permitted_to?(:show, ticket.customer) ? link_to(ticket.customer_name, ticket.customer) : ticket.customer_name,
        status:            ticket.status_name,
        human_status:      ticket.human_status_name,
        human_work_status: ticket.human_work_status_name,
        work_status:       ticket.work_status_name,
        scheduled_for:     ticket.scheduled_for ? l(ticket.scheduled_for) : '',
        contractor:        permitted_to?(:show, ticket.provider) ? link_to(ticket.provider_name, ticket.provider) : ticket.provider_name,
        subcontractor:     permitted_to?(:show, ticket.subcontractor) ? link_to(ticket.subcontractor_name, ticket.subcontractor) : ticket.subcontractor_name,

    }

  end


  def in_progress_jobs_row(ticket)

    {
        ref_id:            ticket.ref_id,
        text:              ticket.name,
        name:              ticket.name,
        human_name:        link_to(ticket.name, ticket),
        status:            ticket.status_name,
        customer:          permitted_to?(:show, ticket.customer) ? link_to(ticket.customer_name, ticket.customer) : ticket.customer_name,
        human_status:      ticket.human_status_name,
        scheduled_for:     ticket.scheduled_for ? l(ticket.scheduled_for) : '',
        contractor:        permitted_to?(:show, ticket.provider) ? link_to(ticket.provider_name, ticket.provider) : ticket.provider_name,
        subcontractor:     permitted_to?(:show, ticket.subcontractor) ? link_to(ticket.subcontractor_name, ticket.subcontractor) : ticket.subcontractor_name,
        human_work_status: ticket.human_work_status_name,
        work_status:       ticket.work_status_name,
    }

  end

  def done_jobs_row(ticket)

    {
        ref_id:                        ticket.ref_id,
        text:                          ticket.name,
        name:                          ticket.name,
        human_name:                    link_to(ticket.name, ticket),
        status:                        ticket.status_name,
        customer:                      permitted_to?(:show, ticket.customer) ? link_to(ticket.customer_name, ticket.customer) : ticket.customer_name,
        human_status:                  ticket.human_status_name,
        completed_on:                  ticket.completed_on ? l(ticket.completed_on) : '',
        contractor:                    permitted_to?(:show, ticket.provider) ? link_to(ticket.provider_name, ticket.provider) : ticket.provider_name,
        subcontractor:                 permitted_to?(:show, ticket.subcontractor) ? link_to(ticket.subcontractor_name, ticket.subcontractor) : ticket.subcontractor_name,
        customer_balance:              ticket.customer_balance.cents,
        customer_balance_ccy_sym:      ticket.customer_balance.currency.symbol,
        subcontractor_balance:         ticket.subcon_balance.cents,
        subcontractor_balance_ccy_sym: ticket.subcon_balance.currency.symbol,
        contractor_balance:            ticket.provider_balance.cents,
        contractor_balance_ccy_sym:    ticket.provider_balance.currency.symbol,
        work_status:                   ticket.work_status_name,
        billing_status:                permitted_to?(:show, ticket.customer) ? ticket.billing_status_name : ''

    }

  end

  def customer_active_jobs_row(ticket)

    {
        ref_id:              ticket.ref_id,
        name:                ticket.name,
        human_name:          link_to(ticket.name, ticket),
        status:              ticket.status_name,
        billing_status:      ticket.billing_status_name,
        human_status:        ticket.human_status_name,
        created_at:          l(ticket.created_at),
        total_price:         ticket.total_price.cents,
        total_price_ccy_sym: ticket.total_price.currency.symbol,
        work_status:         ticket.work_status_name,
        human_work_status:   ticket.human_work_status_name

    }

  end

  def customer_overdue_jobs_row(ticket)

    {
        ref_id:                   ticket.ref_id,
        name:                     ticket.name,
        human_name:               link_to(ticket.name, ticket),
        status:                   ticket.status_name,
        billing_status:           ticket.billing_status_name,
        human_status:             ticket.human_status_name,
        created_at:               l(ticket.created_at),
        customer_balance:         ticket.customer_balance.cents,
        customer_balance_ccy_sym: ticket.customer_balance.currency.symbol,
        work_status:              ticket.work_status_name,
        human_work_status:        ticket.human_work_status_name

    }

  end

  def all_jobs_row(ticket)

    {
        id:                   ticket.id,
        ref_id:               ticket.ref_id,
        created_at:           l(ticket.created_at, format: :no_tz),
        started_on:           ticket.started_on ? l(ticket.started_on, format: :no_tz) : '',
        human_customer:       link_to(ticket.customer.name, ticket.customer),
        human_name:           link_to(ticket.name, ticket),
        human_provider:       link_to(ticket.provider.name, ticket.provider),
        human_subcontractor:  ticket.subcontractor ? link_to(ticket.subcontractor.name, ticket.subcontractor) : '',
        text:                 ticket.name,
        status:               ticket.status_name,
        human_status:         ticket.human_status_name,
        human_work_status:    ticket.human_work_status_name,
        work_status:          ticket.work_status_name,
        human_billing_status: ticket.human_billing_status_name,
        billing_status:       ticket.billing_status_name,
        my_profit:            ticket.my_profit.cents,
        my_profit_ccy_sym:    ticket.my_profit.currency.symbol,
        total_price:          ticket.total_price.cents,
        total_price_ccy_sym:  ticket.total_price.currency.symbol,
        total_cost:           ticket.total_cost.cents,
        total_cost_ccy_sym:   ticket.total_cost.currency.symbol,
        tags:                 ticket.tag_list,
        external_ref:         ticket.external_ref,
        technician_name:      ticket.technician ? ticket.technician_name : ''
    }

  end
end