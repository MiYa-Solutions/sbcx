module Forms::TicketProjectForm
  attr_writer :project_name

  def project_name
    if @project_name.nil?
      project_id ? project.name : ''
    else
      @project_name
    end
  end
end