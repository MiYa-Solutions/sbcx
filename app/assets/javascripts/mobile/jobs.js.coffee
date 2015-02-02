$(document).on "pageshow", '#projects_', ->
  list = $('#job-list').searchable_list(
    url: "/api/v1/service_calls.json?project_id=" + $('#job-list').data('project-id')
    list_template: 'service_calls/show'
  )
