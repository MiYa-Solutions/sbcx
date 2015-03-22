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

      when 'in_progress_jobs'
        tickets.map do |ticket|
          in_progress_jobs_row(ticket)
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
        name:              link_to(ticket.name, ticket),
        status:            ticket.status_name,
        human_status:      ticket.human_status_name,
        human_work_status: ticket.human_work_status_name,
        work_status:       ticket.work_status_name,
    }

  end

  def in_progress_jobs(ticket)

    {
        ref_id:            ticket.ref_id,
        text:              ticket.name,
        name:              link_to(ticket.name, ticket),
        status:            ticket.status_name,
        customer:          ticket.customer.name,
        human_status:      ticket.human_status_name,
        scheduled_for:     l(ticket.scheduled_for),
        contractor:        ticket.provider.name,
        subcontractor:     ticket.subcontractor.name,
        human_work_status: ticket.human_work_status_name,
        work_status:       ticket.work_status_name,
    }

  end
end