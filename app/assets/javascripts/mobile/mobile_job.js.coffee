$(document).live "pageinit", ->
  # dynamic subcon agreement selection
  if $('#service_call_subcontractor_id :selected').data('agreements')

  else
    $('#service_call_subcon_agreement_id').parent().hide()
    $("label[for='"+$('#service_call_subcon_agreement_id').attr('id')+"']").hide()

  $('#service_call_subcontractor_id').change ->
    $('#service_call_subcon_agreement_id').empty()
    options = $('#service_call_subcontractor_id :selected').data('agreements')
    if options
      $("label[for='"+$('#service_call_subcon_agreement_id').attr('id')+"']").show(400)
      $('#service_call_subcon_agreement_id').parent().show(400)
      $.each options, (key, value) ->
        opt = $('<option></option>')
        opt.attr("value", value[1])
        opt.text(value[0])
        $('#service_call_subcon_agreement_id').append(opt)
    else
      $('#service_call_subcon_agreement_id').parent().hide(400)
      $("label[for='"+$('#service_call_subcon_agreement_id').attr('id')+"']").hide(400)


  # dynamic provider agreement selection
  if $('#service_call_provider_id :selected').data('agreements')

  else
    $('#service_call_provider_agreement_id').parent().hide()
    $("label[for='"+$('#service_call_provider_agreement_id').attr('id')+"']").hide()

  $('#service_call_provider_id').change ->
    $('#service_call_provider_agreement_id').empty()
    options = $('#service_call_provider_id :selected').data('agreements')
    if options
      $("label[for='"+$('#service_call_provider_agreement_id').attr('id')+"']").show(400)
      $('#service_call_provider_agreement_id').parent().show(400)
      $.each options, (key, value) ->
        opt = $('<option></option>')
        opt.attr("value", value[1])
        opt.text(value[0])
        $('#service_call_provider_agreement_id').append(opt)
    else
      $('#service_call_provider_agreement_id').parent().hide(400)
      $("label[for='"+$('#service_call_provider_agreement_id').attr('id')+"']").hide(400)

