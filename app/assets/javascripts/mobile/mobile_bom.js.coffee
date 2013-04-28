$(document).live "pageshow", ->
  $('#bom_buyer_id').selectmenu('refresh')
  $('#bom_buyer_id').change (e) ->
    type = $('#bom_buyer_id option:selected').data('type')
    $('#bom_buyer_type').val(type)

  $("#material-autocomplete").autocomplete
    method: 'GET', #// allows POST as well
    icon: 'arrow-r', #// option to specify icon
    target: $('#material-suggestions'), #// the listview to receive results
    source: '/materials/autocomplete_material_name', #// URL return JSON data
    callback: (e) ->
      $a = $(e.currentTarget)
      $('#material-autocomplete').val($a.text())
      $('#service_call_customer_id').val($a.data('autocomplete').id)
      $('#bom_price').val($a.data('autocomplete').price_cents / 100.0)
      $('#bom_cost').val($a.data('autocomplete').cost_cents / 100.0)
      $("#material-autocomplete").autocomplete('clear')
    #link: 'target.html?term=', #// link to be attached to each result
    minLength: 2 #// minimum length of search string
    transition: 'fade',#// page transition, default is fade
    matchFromStart: false, #// search from start, or anywhere in the string
    loadingHtml : '<li data-icon="none"><a href="#">Searching...</a></li>', #// HTML to display when searching remotely
    interval: 3000, #// The minimum delay between server calls when using a remote "source"
    builder : null, #// optional callback to build HTML for autocomplete

