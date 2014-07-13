class TicketsDatatable
  delegate :humanized_money_with_symbol, :current_user, :params, :h, :link_to, :number_to_currency, to: :@view

  def initialize(view)
    @view         = view
  end

  def as_json(options = {})
    {
        sEcho:                params[:sEcho].to_i,
        iTotalRecords:        tickets.size,
        iTotalDisplayRecords: tickets.total_entries,
        aaData:               data,
        yadcf_data_10: current_user.organization.tags.map(&:name)
    }
  end

  private

  def data
    tickets.map do |ticket|
      [
          h(ticket.ref_id),
          h(ticket.created_at.strftime("%b %d, %Y")),
          h(ticket.customer.name),
          h(ticket.provider.name),
          h(ticket.subcontractor.try(:name)),
          h(ticket.human_status_name),
          ticket.provider_balance.to_s,
          ticket.subcon_balance.to_s,
          ticket.total_price.to_s,
          ticket.total_cost.to_s,
          ticket.tags.map(&:name).join(', ')
      ]
    end
  end

  def tickets
    @tickets ||= fetch_tickets
  end

  def fetch_tickets
    tickets = current_user.organization.service_calls.scoped
    if params[:sSearch].present?
      tickets = tickets.where("name ilike :search", search: "#{params[:sSearch]}")
    end

    if params[:sSearch_5].present?
      tickets = tickets.merge(status_scope)
    end

    if params[:sSearch_10].present?
      tickets = tickets.merge(tags_scope)
    end

    if params[:customer_id].present?
      tickets = tickets.where(customer_id: params[:customer_id])
    end

    if params[:provider_id].present?
      tickets = tickets.where(provider_id: params[:provider_id])
    end

    if params[:subcontractor_id].present?
      tickets = tickets.where(subcontractor_id: params[:subcontractor_id])
    end

    if params[:from_date].present? && !params[:to_date].present?
      tickets = tickets.where('created_at >= ?',  params[:from_date])
    end

    if params[:to_date].present? &&  !params[:from_date].present?
      tickets = tickets.where('created_at <= ?',  params[:to_date])
    end

    if params[:to_date].present? &&  params[:from_date].present?
      tickets = tickets.where('created_at between ? and ?', params[:from_date], params[:to_date])
    end


    tickets.order("#{sort_column} #{sort_direction}").page(page).per_page(per_page)
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[id created_at customer_id status]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end

  def status_scope
    status_map = {
        'Closed' => Ticket::STATUS_CLOSED,
        'New' => Ticket::STATUS_NEW,
        'Received New' => Ticket::STATUS_NEW,
        'Open' => Ticket::STATUS_OPEN,
        'Transferred' => Ticket::STATUS_TRANSFERRED,
        'Accepted' => TransferredServiceCall::STATUS_ACCEPTED,
        'Rejcted' => TransferredServiceCall::STATUS_REJECTED,
        'Canceled' => Ticket::STATUS_CANCELED
    }

    Ticket.where(status: status_map[params[:sSearch_5]])
  end

  def tags_scope
    term = params[:sSearch_10].sub('|', ', ')
    Ticket.joins(:tags).where("tags.name = '#{params[:sSearch_10]}'")
  end

end