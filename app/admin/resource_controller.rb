class ActiveAdmin::ResourceController
  def comment_params
    params.permit!
  end

  def permitted_params
    params.permit!
  end


end