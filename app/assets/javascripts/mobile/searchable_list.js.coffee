class SearchableList
  constructor: (element, options) ->
    @element = element
    @current_page = 1
    @search_results = '#searchable-list'
    @search_term = '#project-search'
    @search_page = '#project-search-page'
    @url = options.url
    @list_template = options.list_template

    $('#list-search-btn').click =>
      @fetch_data()
    $('#list-next-btn').click =>
      @next_page()

    $('#list-prev-btn').click =>
      @prev_page()

    @fetch_data()


  next_page: =>
    @current_page = @current_page + 1
    @fetch_data()

  prev_page: =>
    @current_page = @current_page - 1
    @fetch_data()

  fetch_data: =>
    $.ajax
      url: @url
      dataType: "json"
      mimeType: 'application/json'
      data:
        sSearch: $(@search_term).val()
        iDisplayStart: @current_page
        iDisplayLength: 2
      success: (result) =>
        $("#{@search_results} li").remove()
        $(@search_results).append(HandlebarsTemplates[@list_template]({ list: result.aaData}))
        $(@search_results).listview('refresh')



$.fn.searchable_list = (options) ->
  settings = $.extend
    url: '/projects.json'
    list_template: 'projects/project-list'
  this.each ->
    list = new SearchableList(this, settings)
#    list.fetch_data()

$(document).live "pageinit", '#projects', ->
  list = $('#searchable-list').searchable_list(
    url: '/projects.json'
    list_template: 'projects/project-list'
  )


