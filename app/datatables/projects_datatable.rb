class ProjectsDatatable
  delegate :humanized_money_with_symbol, :current_user, :params, :h, :link_to, :number_to_currency, :affiliate_path, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
        sEcho:                params[:sEcho].to_i,
        iTotalRecords:        projects.size,
        iTotalDisplayRecords: projects.total_entries,
        aaData:               data,
    }
  end

  def table_row(project)
    {
        id:            project.id,
        created_at:    h(project.created_at.strftime("%b %d, %Y")),
        name:          link_to(project.name, project),
        text:          project.name,
        status:        project.status_name,
        human_status:  project.human_status_name,
        customer:      project.customer ? link_to(project.customer_name, project.customer) : '',
        customer_name: project.customer ? project.customer_name : '',
        provider:      project.provider ? link_to(project.provider_name, affiliate_path(project.provider)) : '',
    }

  end


  private

  def data
    projects.map do |project|
      table_row(project)
    end
  end

  def projects
    @projects ||= fetch_projects
  end

  def fetch_projects
    result_set = current_user.organization.projects.scoped
    if params[:sSearch].present?
      result_set = result_set.where("projects.name ilike ? OR projects.external_ref ilike ?", "%#{params[:sSearch]}%", "%#{params[:sSearch]}%")
    end

    if params[:sSearch_4].present?
      result_set = result_set.merge(status_scope)
    end


    if params[:customer_id].present?
      result_set = result_set.where(customer_id: params[:customer_id])
    end

    if params[:provider_id].present?
      if params[:provider_id] == '-1'
        result_set = result_set.where(provider_id: nil)
      else
        result_set = result_set.where(provider_id: params[:provider_id])
      end
    end

    if params[:from_date].present? && !params[:to_date].present?
      result_set = result_set.where('projects.created_at >= ?', Time.zone.parse(params[:from_date]))
    end

    if params[:to_date].present? && !params[:from_date].present?
      result_set = result_set.where('projects.created_at < ?', Time.zone.parse(params[:to_date]))
    end

    if params[:to_date].present? && params[:from_date].present?
      result_set = result_set.where('projects.created_at between ? and ?',Time.zone.parse(params[:from_date]) , Time.zone.parse(params[:to_date]))
      # result_set = result_set.where('projects.created_at >= ?', params[:from_date] ).where('projects.created_at =< ?', params[:to_date])
      # result_set = result_set.where(create_at: Date.parse(params[:from_date]..Date.parse(params[:to_date])))
    end

    result_set.order("projects.#{sort_column} #{sort_direction}").page(page).per_page(per_page)
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
    term = params[:sSearch_4].split('|').map { |t| status_map[t] }
    Project.where('projects.status in (?)', term)
  end

  def tags_scope
    term = params[:sSearch_10].split('|')
    Ticket.joins(:tags).where("tags.name in (?)", term)
  end

  def status_map
    {
        Project.human_status_name(:new)         => Project::STATUS_NEW,
        Project.human_status_name(:in_progress) => Project::STATUS_IN_PROGRESS,
        Project.human_status_name(:closed)      => Project::STATUS_CLOSED,
        Project.human_status_name(:canceled)    => Project::STATUS_CANCELED,
        Project.human_status_name(:completed)   => Project::STATUS_COMPLETED,
        Project.human_status_name(:on_hold)     => Project::STATUS_ON_HOLD
    }
  end


end