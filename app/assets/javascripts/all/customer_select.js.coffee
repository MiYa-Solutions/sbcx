$ ->
  $('select#service_call_provider_id').change (event) ->
    $('#service_call_customer_name').attr("data-ref-id", $('select#service_call_provider_id').val())