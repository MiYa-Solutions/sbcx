class Api::V1::Datatables::Datatable
  delegate :humanized_money_with_symbol, :current_user, :params, :h, :l, :link_to, :number_to_currency, :permitted_to?, to: :@view

  def initialize(view)
    @view = view

  end

  def table_columns
    params[:columns]
  end

  def col_order
    params[:order]
  end

  def col_search
    # res = {}
    table_columns.select { |key, value|
      value[:searchable] == 'true'
    }
      # table_columns.each_with_index { |col,index |
      #   res << "index:[#{index}], col_key:[#{col[0]}] col_props:[#{col[1]}]"
      # }
      # res
  end

  def search_value
    params[:search] ? params[:search][:value] : nil
  end

  def as_json(options = {})
    {
        draw:            params[:sEcho].to_i,
        recordsTotal:    records.size,
        recordsFiltered: records.total_entries,
        data:            data,
    }
  end

  protected

  def records
    @records ||= fetch_records
  end

  def fetch_records
    scope = initial_scope
    scope = search_filter(scope) if search_value.present?
    scope = custom_filters(scope)

    scope.order(order_string).page(page).per_page(per_page)
  end

  def search_filter(scope)
    query = ''
    col_search.each_with_index do |col_data, col_id|
      query = query + "CAST(#{col_data[1][:name]} AS TEXT) ilike '%#{search_value}%'"
      query = query + ' OR ' unless col_search.size == (col_id + 1) #reached the the last item

    end
    # scope.merge(scope.klass.where(query))
    scope.where(query)

  end

  def initial_scope
    current_user.organization.service_calls.scoped
  end

  # to be implemented by subclass
  def custom_filters(scope)
    scope
  end

  def order_string
    res = ''
    col_order.each do |index, col_data|
      res = res +"#{table_name}.#{table_columns[col_data[:column]][:name]} #{col_data[:dir]}"
    end
    res
  end

  def page
    params[:start].to_i/per_page + 1
  end

  def per_page
    params[:length].to_i > 0 ? params[:length].to_i : 10
  end



end