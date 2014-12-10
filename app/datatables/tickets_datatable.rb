class TicketsDatatable
  delegate :humanized_money_with_symbol, :current_user, :params, :h, :link_to, :number_to_currency, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
        sEcho:                params[:sEcho].to_i,
        iTotalRecords:        tickets.size,
        iTotalDisplayRecords: tickets.total_entries,
        aaData:               data,
    }
  end

  private

  def data
    case params[:table_type]
      when 'customer_active_jobs'
        tickets.map do |ticket|
          [
              h(ticket.ref_id),
              h(ticket.created_at.strftime("%b %d, %Y")),
              link_to(ticket.name, ticket),
              h(ticket.human_work_status_name),
              humanized_money_with_symbol(ticket.total_price)
          ]
        end
      when 'customer_overdue_jobs'
        tickets.map do |ticket|
          [
              ticket.ref_id,
              h(ticket.created_at.strftime("%b %d, %Y")),
              link_to(ticket.name, ticket),
              h(ticket.human_work_status_name),
              humanized_money_with_symbol(ticket.customer_balance)
          ]
        end
      when 'job_search'
        tickets.map do |ticket|
          [
              ticket.ref_id,
              ticket.name,
              ticket.human_status_name,
              ticket.human_work_status_name,
              ticket.human_billing_status_name
          ]
        end
      when 'project_jobs'
        tickets.map do |ticket|
          [
              ticket.ref_id,
              link_to(ticket.name, ticket),
              ticket.human_status_name,
              ticket.human_work_status_name,
              ticket.human_billing_status_name
          ]
        end
      else
        tickets.map do |ticket|
          [
              h(ticket.ref_id),
              h(ticket.created_at.strftime("%b %d, %Y")),
              h(ticket.customer.name),
              link_to(ticket.name, ticket),
              h(ticket.provider.name),
              h(ticket.subcontractor.try(:name)),
              h(ticket.human_status_name),
              ticket.my_profit.to_s,
              ticket.total_price.to_s,
              ticket.total_cost.to_s,
              ticket.tags.map(&:name).join(', ')
          ]
        end

    end
  end

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

    if params[:account_id].present?
      account = Account.find params[:account_id]
      case account.accountable_type
        when 'Organization'
          tickets = tickets.where("provider_id = #{account.accountable_id} OR subcontractor_id = #{account.accountable_id} ")
        when
          tickets = tickets.where(customer_id: account.accountable_id)
        else

      end

    end

    if params[:billing_status].present?
      tickets = tickets.where(billing_status: params[:billing_status])
    end

    if params[:work_status].present?
      tickets = tickets.where(work_status: params[:work_status])
    end

    if params[:project_id].present?
      tickets = tickets.where(project_id: params[:project_id])
    end



    tickets.order("tickets.#{sort_column} #{sort_direction}").page(page).per_page(per_page)
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
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