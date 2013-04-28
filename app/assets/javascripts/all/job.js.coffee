jQuery ->
  $(".ajax-form.service_call").bind("ajax:success", (e, data, status, xhr)->
    $('#tag_list').html(data.tag_list)
    $('#service_call_tag_list').val(data.tag_list)
    $('#tags').collapse('toggle')

  )
  $('#service_call_state').select2()

  $('#service_call_country').hide()
  $('.customer-autocomplete').live "click", ->
    orig = $(this).clone()
    input_str =  ['<input type="text" size="30" name="',orig.data('obj-type'), '[customer]" id="service_call_customer" data-update-elements="{&quot;id&quot;:&quot;#service_call_customer_id&quot;}" data-ref-id="" data-autocomplete="/service_calls/autocomplete_customer_name"><input type="hidden" name=" ', orig.data('obj-type'), '[customer_id]" id="service_call_customer_id">'].join("")
    console.log (input_str)
    input = $(input_str)

#    input = $('<input type="text" size="30" name="service_call[customer]" id="service_call_customer" data-update-elements="{&quot;id&quot;:&quot;#service_call_customer_id&quot;}" data-ref-id="" data-autocomplete="/service_calls/autocomplete_customer_name"><input type="hidden" name="service_call[customer_id]" id="service_call_customer_id">')
    $(this).replaceWith(input)

    input.focusout (e) ->

      $.ajax
        type: "put"
        dataType: "json"
        url: "/service_calls/" + orig.data('job-id')

        data:
          service_call:
            customer_id: $('#service_call_customer_id').val()
          my_service_call:
            customer_id: $('#service_call_customer_id').val()
          transferred_service_call:
            customer_id: $('#service_call_customer_id').val()

        beforeSend: ->
          orig.html($(e.target).val())
          $(e.target).before(orig)
          $(e.target).remove()

        success: (response) ->
          msg = $("<span class='alert-success'>Saved!</span>").appendTo($(orig))
          msg.fadeOut(1500)

        error: (response) ->
          res = $.parseJSON(response)
          container = $("<span class='flash-error'></span>").html(response.responseText)
          container.purr()


  $('#service_call_customer_name').bind 'railsAutocomplete.select', (e, data)->
    $('#service_call_state').select2("val", data.item.state)

  # dynamic subcon agreement selection
  $('#service_call_subcon_agreement_id').hide()
  $("label[for='"+$('#service_call_subcon_agreement_id').attr('id')+"']").hide()
  $('#service_call_subcontractor_id').change ->
    $('#service_call_subcon_agreement_id').empty()
    options = $('#service_call_subcontractor_id :selected').data('agreements')
    if options
      $("label[for='"+$('#service_call_subcon_agreement_id').attr('id')+"']").show(400)
      $('#service_call_subcon_agreement_id').show(400)
      $.each options, (key, value) ->
        opt = $('<option></option>')
        opt.attr("value", value[1])
        opt.text(value[0])
        $('#service_call_subcon_agreement_id').append(opt)
    else
      $('#service_call_subcon_agreement_id').hide(400)
      $("label[for='"+$('#service_call_subcon_agreement_id').attr('id')+"']").hide(400)


  # dynamic provider agreement selection
  if $('#service_call_provider_id :selected').data('agreements')

  else
    $('#service_call_provider_agreement_id').hide()
    $("label[for='"+$('#service_call_provider_agreement_id').attr('id')+"']").hide()

  $('#service_call_provider_id').change ->
    $('#service_call_provider_agreement_id').empty()
    options = $('#service_call_provider_id :selected').data('agreements')
    if options
      $("label[for='"+$('#service_call_provider_agreement_id').attr('id')+"']").show(400)
      $('#service_call_provider_agreement_id').show(400)
      $.each options, (key, value) ->
        opt = $('<option></option>')
        opt.attr("value", value[1])
        opt.text(value[0])
        $('#service_call_provider_agreement_id').append(opt)
    else
      $('#service_call_provider_agreement_id').hide(400)
      $("label[for='"+$('#service_call_provider_agreement_id').attr('id')+"']").hide(400)

