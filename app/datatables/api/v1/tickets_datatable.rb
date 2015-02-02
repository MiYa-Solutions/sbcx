class Api::V1::TicketsDatatable < TicketsDatatable

  def table_row(ticket)

    {
        id: ticket.id,
        ref_id: ticket.ref_id,
        text: ticket.name,
        status: ticket.status_name,
        human_status: ticket.human_status_name,
        human_work_status: ticket.human_work_status_name,
        work_status: ticket.work_status_name,
        human_billing_status: ticket.human_billing_status_name,
        billing_status: ticket.billing_status_name
    }

  end

  protected

  def data
    tickets.map do |ticket|
      table_row(ticket)
    end
  end
end