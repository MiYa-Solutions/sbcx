class TicketsDatatable
  delegate :humanized_money_with_symbol, :current_user, :params, :h, :link_to, :number_to_currency, to: :@view

  def initialize(view)
    @view         = view
    @affiliate_id = params[:affiliate_id]
    @customer_id  = params[:customer_id]
    @account_id   = params[:account_id]
  end

  def as_json(options = {})
    {
        sEcho:                params[:sEcho].to_i,
        iTotalRecords:        data.size,
        iTotalDisplayRecords: tickets.size,
        aaData:               data
    }
  end

  private

  def data
    tickets.map do |ticket|
      [
          h(ticket.ref_id),
          h(ticket.created_at.strftime("%B %e, %Y, %H:%m")),
          h(ticket.customer.name),
          h(ticket.human_status_name),
          humanized_money_with_symbol(ticket.total_price),
          humanized_money_with_symbol(ticket.total_cost)
      ]
    end
  end

  def tickets
    @tickets ||= fetch_tickets
  end

  def fetch_tickets
    tickets = current_user.organization.service_calls.scoped
    if @account_id.present?
      acc = Account.find(@account_id)

      case acc.accountable_type
        when 'Customer'
          tickets = tickets.customer_jobs(current_user.organization, acc.accountable)
        when 'Organization'
          tickets = tickets.affiliated_jobs(current_user.organization, acc.accountable)
        else
          raise 'unrecognized account type when fetching tickets'
      end

    else
      if @affiliate_id.present?
        aff     = Affiliate.find(@affiliate_id)
        tickets = tickets.affiliated_jobs(current_user.organization, aff)
      end
      if @customer_id.present?
        cus     = Customer.find(@customer_id)
        tickets = tickets.customer_jobs(current_user.organization, cus)
      end

    end
    if params[:sSearch].present?
      tickets = tickets.where("name ilike :search", search: "#{params[:sSearch]}")
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

end