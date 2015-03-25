class Api::V1::TicketsDatatable < TicketsDatatable

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

  def data
    case params[:table_type]
      when 'open_jobs'
        tickets.map do |ticket|
          open_jobs_row(ticket)
        end

      when 'new_jobs'
        tickets.map do |ticket|
          new_jobs_row(ticket)
        end

      when 'new_transferred_jobs'
        tickets.map do |ticket|
          new_jobs_row(ticket)
        end

      when 'in_progress_jobs'
        tickets.map do |ticket|
          in_progress_jobs_row(ticket)
        end

      when 'transferred_in_progress_jobs'
        tickets.map do |ticket|
          in_progress_jobs_row(ticket)
        end

      when 'done_jobs'
        tickets.map do |ticket|
          done_jobs_row(ticket)
        end

      when 'done_transferred_jobs'
        tickets.map do |ticket|
          done_jobs_row(ticket)
        end

      else

        tickets.map do |ticket|
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
end