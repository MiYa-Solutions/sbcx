#class ProjectSearcher
#  search_results: '#projects-list'
#  search_term: '#project-search'
#  search_page: '#project-search-page'
#  url: '/projects.json', #// URL return JSON data
#  search: =>
#    $.ajax
#      url: @url
#      dataType: "json"
#      mimeType: 'application/json'
#      data:
#        sSearch: $(@search_term).val()
#        iDisplayStart: $(@search_page).val()
#        iDisplayLength: 2
#      success: (result) =>
#        $("#{@search_results} li").empty()
#        $(@search_results).append(HandlebarsTemplates['projects/project-list']({ projects: result.aaData}))
#        $(@search_results).listview('refresh')
#
#  next_page: =>
#    $(@search_page).val($(@search_page).val() + 1)
#    @fetch_more()
#
#
#  prev_page: =>
#    $(@search_page).val($(@search_page).val() - 1 )
#    @fetch_more()
#
#  fetch_more: =>
#    $.ajax
#      url: @url
#      dataType: "json"
#      mimeType: 'application/json'
#      data:
#        sSearch: $(@search_term).val()
#        iDisplayStart: $(@search_page).val()
#      success: (result) =>
#        $(@search_results).append(HandlebarsTemplates['projects/project-list']({ projects: result.aaData}))
#        $(@search_results).listview('refresh')
#
#
#
#$(document).on "pageshow", '#projects', ->
#  searcher = new ProjectSearcher
#  $.ajax(
#    url: '/projects.json', #// URL return JSON data
#    dataType: "json"
#    mimeType: 'application/json'
#    data: []
#    success: (result) ->
#      $('#projects-list').append(HandlebarsTemplates['projects/project-list']({ projects: result.aaData}))
#      $('#projects-list').listview('refresh')
#    error: (request, error) ->
#      alert "Network error has occurred please try again!"
#  )
#
#  $('#project-search-btn').click ->
#    searcher.search()
#
#  $('#project-next-btn').click ->
#    searcher.next_page()
#
#  $('#project-prev-btn').click ->
#    searcher.prev_page()
#
