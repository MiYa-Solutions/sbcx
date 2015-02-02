class SearchableList
  constructor: (element, options) ->
    @page_size = 10
    @element = element
    @current_page = 0
    @total_records = 0
    @search_results = '#searchable-list'
    @search_term = '#searchable-list-search'
    @url = options.url
    @list_template = options.list_template
    $(@element).append(HandlebarsTemplates['searchable-list/searchable-list']())
    $(@search_results).listview()

    $('#list-search-btn').click =>
      @reset_page_data()
      @fetch_data()
    $('#list-next-btn').click =>
      @next_page()

    $('#list-prev-btn').click =>
      @prev_page()

    @fetch_data()


  next_page: =>
    if @is_next_page
      @current_page = @next_page_location()
      @fetch_data()

  prev_page: =>
    if @is_prev_page()
      @current_page = @prev_page_location()
      @fetch_data()

  is_next_page: =>
    @next_page_location() < @total_records

  is_prev_page: =>
    @prev_page_location() >= 0

  next_page_location: =>
    @current_page + @page_size

  prev_page_location: =>
    @current_page - @page_size

  reset_page_data: =>
    @total_records = 0
    @current_page = 0



  fetch_data: =>

    $.ajax
      url: @url
      dataType: "json"
      mimeType: 'application/json'
      data:
        sSearch: $(@search_term).val()
        iDisplayStart: @current_page
        iDisplayLength: @page_size
      success: (result) =>
        $("#{@search_results} li").remove()
        $(@search_results).append(HandlebarsTemplates[@list_template]({ list: result.aaData}))
        $(@search_results).listview('refresh')
        $('#total-records').text(result.iTotalDisplayRecords)
        $('#showing').text(result.iTotalRecords)
        @total_records = result.iTotalDisplayRecords
        $('#first-record').text(@current_page +  1)
        $('#last-record').text(@current_page + result.aaData.length)
        $('#record-count').text(result.aaData.length)
        $('#list-next-btn').addClass('ui-disabled') unless @is_next_page()
        $('#list-next-btn').removeClass('ui-disabled') if @is_next_page()
        $('#list-prev-btn').addClass('ui-disabled') unless @is_prev_page()
        $('#list-prev-btn').removeClass('ui-disabled') if @is_prev_page()


$.fn.searchable_list = (options) ->

  settings = $.extend {}, $.fn.searchable_list.defaults, options
  this.each ->
    list = new SearchableList(this, settings)

$.fn.searchable_list.defaults =
  url: '/projects.json'
  list_template: 'projects/project-list'



