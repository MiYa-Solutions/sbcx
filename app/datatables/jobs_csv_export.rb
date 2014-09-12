require 'csv'
class JobsCsvExport
  delegate :humanized_money_with_symbol, :current_user, :params, :h, :link_to, :number_to_currency, to: :@view

  def initialize(view)
    @view = view
  end

  def get_csv(options = {})
    CSV.generate(options) do |csv|
      csv << ServiceCall.column_names
      tickets.each do |ticket|
        csv << ticket.attributes.values_at(*ServiceCall.column_names)
      end
    end
  end

  private

  def tickets
    @tickets ||= fetch_tickets
  end

  def fetch_tickets
    tickets = current_user.organization.service_calls.scoped
    if params[:sSearch].present?
      tickets = tickets.where("tickets.name ilike ?", "%#{params[:sSearch]}%")
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
      tickets = tickets.where('tickets.created_at >= ?', params[:from_date])
    end

    if params[:to_date].present? && !params[:from_date].present?
      tickets = tickets.where('tickets.created_at <= ?', params[:to_date])
    end

    if params[:to_date].present? && params[:from_date].present?
      tickets = tickets.where('tickets.created_at between ? and ?', params[:from_date], params[:to_date])
    end

    if params[:affiliate_id].present?
      tickets = tickets.where("provider_id = #{params[:affiliate_id]} OR subcontractor_id = #{params[:affiliate_id]} ")
    end


    tickets.order("tickets.#{sort_column} #{sort_direction}")
  end

  def sort_column
    columns = %w[id]
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