$(document).on "pageinit", '#projects', ->
  list = $('#projects-list').searchable_list(
    url: '/projects.json'
    list_template: 'projects/project-list'
  )
