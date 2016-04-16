$(document).bind "pageshow", (e) ->
  $('select#project_provider_id').change (event) ->
    $('#customer-autocomplete').attr("data-ref-id", $('select#project_provider_id').val())
    $('#customer-autocomplete').val('')
    $('#project_customer_id').val('')

  $("#project-autocomplete").autocomplete
    method: 'GET', #// allows POST as well
    icon: 'arrow-r', #// option to specify icon
    target: $('#project-suggestions'), #// the listview to receive results
    source: (request, response) ->
      params = {term: request}
#      params['ref_id'] = $("#customer-autocomplete").attr('data-ref-id')
      $.ajax(
        url: '/projects/autocomplete_project_name', #// URL return JSON data
        dataType: "json",
        data: params,
        success: (data)->
          if data.length == 0
            response([label: "Nothing found", value: ''])
          else
            response(data)
      )
    callback: (e) ->
      $a = $(e.currentTarget)
      $("#project-autocomplete").val($a.text())
      $('#service_call_project_id').val($a.data('autocomplete').id)
      $("#project-autocomplete").autocomplete('clear')
    minLength: 2 #// minimum length of search string
    transition: 'fade', #// page transition, default is fade
    matchFromStart: false, #// search from start, or anywhere in the string
    loadingHtml: '<li data-icon="none"><a href="#">Searching...</a></li>', #// HTML to display when searching remotely
    interval: 3000, #// The minimum delay between server calls when using a remote "source"
    builder: null, #// optional callback to build HTML for autocomplete
#labelHTML: fn(){}, // optioanl callback function when formatting the display value of list items
#onNoResults: fn(), // optional callback function when no results were matched
#onLoading: fn(), // optional callback function called just prior to ajax call
#onLoadingFinished: fn(), // optioanl callback function called just after ajax call has completed
