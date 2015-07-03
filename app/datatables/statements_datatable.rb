class StatementsDatatable
  delegate :humanized_money_with_symbol, :current_user, :params, :h, :link_to, :number_to_currency, :affiliate_path, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
        sEcho:                params[:sEcho].to_i,
        iTotalRecords:        statements.size,
        iTotalDisplayRecords: statements.total_entries,
        aaData:               data,
    }
  end

  def table_row(statement)
    {
        id:            link_to(statement.id,statement),
        created_at:    h(statement.created_at.strftime("%b %d, %Y")),
        balance:       humanized_money_with_symbol(statement.balance)
    }

  end


  private

  def data
    statements.map do |statement|
      table_row(statement)
    end
  end

  def statements
    @statements ||= fetch_statements
  end

  def fetch_statements
    result_set = Statement.where(account_id: params[:statement][:account_id])
    if params[:sSearch].present?
      result_set = result_set.where("statements.data ilike ?", "%#{params[:sSearch]}%")
    end


    if params[:from_date].present? && !params[:to_date].present?
      result_set = result_set.where('statements.created_at >= ?', Time.zone.parse(params[:from_date]))
    end

    if params[:to_date].present? && !params[:from_date].present?
      result_set = result_set.where('statements.created_at < ?', Time.zone.parse(params[:to_date]))
    end

    if params[:to_date].present? && params[:from_date].present?
      result_set = result_set.where('statements.created_at between ? and ?',Time.zone.parse(params[:from_date]) , Time.zone.parse(params[:to_date]))
      # result_set = result_set.where('projects.created_at >= ?', params[:from_date] ).where('projects.created_at =< ?', params[:to_date])
      # result_set = result_set.where(create_at: Date.parse(params[:from_date]..Date.parse(params[:to_date])))
    end

    result_set.order("statements.#{sort_column} #{sort_direction}").page(page).per_page(per_page)
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
    params[:sSortDir_0] == 'asc' ? 'asc' : 'desc'
  end


end