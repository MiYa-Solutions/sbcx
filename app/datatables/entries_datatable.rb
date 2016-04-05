class EntriesDatatable
  delegate :render_to_string, :humanized_money_with_symbol, :current_user, :params, :h, :adjustment_entry_actions, :link_to, :number_to_currency, to: :@view

  def initialize(view, account)
    @view    = view
    @account = account
  end

  def as_json(options = {})
    if @account.present?
      {
          sEcho:                params[:sEcho].to_i,
          iTotalRecords:        @account.entries.size,
          iTotalDisplayRecords: entries.total_entries,
          aaData:               data
      }
    else
      {
          sEcho:                params[:sEcho].to_i,
          iTotalRecords:        0,
          iTotalDisplayRecords: 0,
          aaData:               []

      }
    end

  end

  def table_row(entry)
    {
        id: entry.id,
        created_at: h(entry.created_at.strftime("%B %e, %Y, %H:%m")),
        ref_id: link_to(entry.ticket.ref_id, entry.ticket),
        type: entry.type,
        human_type: entry.type.constantize.model_name.human,
        status: entry.status_name,
        human_status: entry.human_status_name,
        amount: humanized_money_with_symbol(entry.amount),
        balance: humanized_money_with_symbol(entry.balance),
        actions: adjustment_entry_actions(entry, 'customer_entry_small_btn'),
        notes: entry.notes,
        collector_name: entry.respond_to?(:collector) ? entry.collector.try(:name) : ''
    }

  end
  private

  def data
    entries.map do |entry|
      table_row(entry)
    end
  end

  def entries
    @entries ||= fetch_entries
  end

  def fetch_entries
    entries = @account.entries.order("#{sort_column} #{sort_direction}")
    entries = entries.page(page).per_page(per_page)
    if params[:sSearch].present?
      entries = entries.where("ticket_id = :search", search: "#{params[:sSearch]}")
    end
    entries
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[id created_at ticket_id type status amount_cents balance_cents]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end

end