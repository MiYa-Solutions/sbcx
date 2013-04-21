$(document).bind "pageshow", (e) ->
  $("#customer-autocomplete").autocomplete
    method: 'GET', #// allows POST as well
    icon: 'arrow-r', #// option to specify icon
    target: $('#customer-suggestions'), #// the listview to receive results
    source: '/service_calls/autocomplete_customer_name', #// URL return JSON data
    callback: (e) ->
      $a = $(e.currentTarget)
      $('#customer-autocomplete').val($a.text())
      $('#service_call_customer_id').val($a.data('autocomplete').id)
      $('#service_call_address1').val($a.data('autocomplete').address1)
      $('#service_call_address2').val($a.data('autocomplete').address2)
      $('#service_call_company').val($a.data('autocomplete').company)
      $('#service_call_city').val($a.data('autocomplete').phone)
      $('#service_call_zip').val($a.data('autocomplete').zip)
      $('#service_call_state').val($a.data('autocomplete').state)
      $('#service_call_state').selectmenu('refresh');
      $('#service_call_phone').val($a.data('autocomplete').phone)
      $('#service_call_mobile_phone').val($a.data('autocomplete').mobile_phone)
      $('#service_call_work_phone').val($a.data('autocomplete').work_phone)
      $('#service_call_email').val($a.data('autocomplete').email)
      $("#customer-autocomplete").autocomplete('clear')
    #link: 'target.html?term=', #// link to be attached to each result
    minLength: 2 #// minimum length of search string
    transition: 'fade',#// page transition, default is fade
    matchFromStart: false, #// search from start, or anywhere in the string
    loadingHtml : '<li data-icon="none"><a href="#">Searching...</a></li>', #// HTML to display when searching remotely
    interval: 3000, #// The minimum delay between server calls when using a remote "source"
    builder : null, #// optional callback to build HTML for autocomplete
    #labelHTML: fn(){}, // optioanl callback function when formatting the display value of list items
    #onNoResults: fn(), // optional callback function when no results were matched
    #onLoading: fn(), // optional callback function called just prior to ajax call
    #onLoadingFinished: fn(), // optioanl callback function called just after ajax call has completed
