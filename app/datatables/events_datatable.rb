class EventsDatatable
  delegate :humanized_money_with_symbol, :current_user, :params, :h, :link_to, :number_to_currency, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
        sEcho:                params[:sEcho].to_i,
        iTotalRecords:        events.size,
        iTotalDisplayRecords: events.total_entries,
        aaData:               data,
    }
  end

  private

  def data
    events.map do |event|
      [
          h(event.created_at.strftime("%b %d, %Y %H:%M")),
          event.reference_id,
          event.name,
          event.description,
          event.creator.name
      ]
    end
  end

  def events
    @events ||= fetch_events
  end

  def fetch_events
    events = Event.scoped
    if params[:sSearch].present?
      events = events.where("events.name ilike ?", "%#{params[:sSearch]}%")
    end

    if params[:eventable_id]
      events = events.where(eventable_id: params[:eventable_id])
    end

    if params[:eventable_type]
      events = events.where(eventable_type: params[:eventable_type])
    end

    if params[:from_date].present? && !params[:to_date].present?
      events = events.where('events.created_at >= ?', params[:from_date])
    end

    if params[:to_date].present? && !params[:from_date].present?
      events = events.where('events.created_at <= ?', params[:to_date])
    end

    if params[:to_date].present? && params[:from_date].present?
      events = events.where('events.created_at between ? and ?', params[:from_date], params[:to_date])
    end

    events.order("events.#{sort_column} #{sort_direction}").page(page).per_page(per_page)
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[created_at]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end

  def status_scope
    term = params[:sSearch_5].split('|').map { |t| status_map[t] }
    Ticket.where('tickets.status in (?)', term)
  end

  def tags_scope
    term = params[:sSearch_10].split('|')
    Ticket.joins(:tags).where("tags.name in (?)", term)
  end

  def status_map
    {
        'Closed'       => Ticket::STATUS_CLOSED,
        'New'          => Ticket::STATUS_NEW,
        'Received New' => Ticket::STATUS_NEW,
        'Open'         => Ticket::STATUS_OPEN,
        'Transferred'  => Ticket::STATUS_TRANSFERRED,
        'Passed On'    => Ticket::STATUS_TRANSFERRED,
        'Accepted'     => TransferredServiceCall::STATUS_ACCEPTED,
        'Rejcted'      => TransferredServiceCall::STATUS_REJECTED,
        'Canceled'     => Ticket::STATUS_CANCELED
    }
  end

end