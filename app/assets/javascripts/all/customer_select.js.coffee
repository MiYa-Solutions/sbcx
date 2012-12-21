$ ->
  $('select#service_call_provider_id').change (event) ->
    #    select_wrapper = $('#service_call_customer_id')
    #
    #    $('select', select_wrapper).attr("disabled", "disabled")
    #
    #    org_id = $(this).val()
    #    form_id = $(this.form).prop('id')
    #
    #    url = "/customers?organization_id=#{org_id}&form_id=#{form_id}"
    #    $.ajax(url)
    #    $('select', select_wrapper).attr("disabled", "enabled")
    $('#service_call_customer').attr("data-ref-id", $('select#service_call_provider_id').val())