agr_props = null
show_agr_props = (obj) ->
  if obj.data('props')
    $(agr_props).hide(400)
    agr_props = "#" + obj.data('props')
    $(agr_props).show(400)
  else
    $(agr_props).hide(400)

update_agreement_select = (affilaite_select, agreement_select) ->
  options = affilaite_select.find(":selected").data("agreements")
  if options
    build_agreement_select(agreement_select, options)
  else
    hide_agreement_select(agreement_select)

build_agreement_select = (obj, options) ->
  $(agr_props).hide() if agr_props != null
  $.each options, (key, value) ->
    opt = $('<option></option>')
    opt.attr("value", value[1])
    opt.text(value[0])
    opt.data('props', value[2])
    obj.append(opt)
  $("label[for='" + obj.attr('id') + "']").show(400)
  obj.show(400)
  show_agr_props(obj.find(":selected"))

hide_agreement_select = (obj) ->
  obj.empty()
  obj.hide(400)
  $("label[for='" + obj.attr('id') + "']").hide(400)

jQuery ->
  $('#new_service_call').on 'submit', ->
    if $('#service_call_address1').val() == ''
      res = confirm('Address is empty - do you really want to create the job?');
      $('#service_call_create_btn').attr('disabled', true) if res
      return res
    else
      $('#service_call_create_btn').attr('disabled', true)

  $(".best_in_place").bind "ajax:success", ->
    $(this).JQtextile "textile", @innerHTML  if $(this).attr("data-type") is "textarea"

  $(".ajax-form.service_call").bind("ajax:success", (e, data, status, xhr)->
    $('#tag_list').html(data.tag_list)
    $('#service_call_tag_list').val(data.tag_list)
    $('#tags').collapse('toggle')

  )
  $('#service_call_state').select2()

  $('#service_call_country').hide()
  $('.customer-autocomplete').live "click", ->
    orig = $(this).clone()
    input_str = ['<input type="text" size="30" name="', orig.data('obj-type'),
                 '[customer]" id="service_call_customer" data-update-elements="{&quot;id&quot;:&quot;#service_call_customer_id&quot;}" data-ref-id="" data-autocomplete="/service_calls/autocomplete_customer_name"><input type="hidden" name=" ',
                 orig.data('obj-type'), '[customer_id]" id="service_call_customer_id">'].join("")
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
  update_agreement_select($('#service_call_subcontractor_id'), $('#service_call_subcon_agreement_id'))
  $('#service_call_subcontractor_id').change ->
    $(agr_props).hide(400)
    update_agreement_select($('#service_call_subcontractor_id'), $('#service_call_subcon_agreement_id'))

  # dynamic provider agreement selection
  update_agreement_select($('#service_call_provider_id'), $('#service_call_provider_agreement_id'))
  $('#service_call_provider_id').change ->
    $(agr_props).hide(400)
    update_agreement_select($('#service_call_provider_id'), $('#service_call_provider_agreement_id'))

  # dynamic subcon agreement properties
  $('#service_call_subcon_agreement_id').change ->
    show_agr_props($('#service_call_subcon_agreement_id :selected'))

  # dynamic provider agreement properties
  $('#service_call_provider_agreement_id').change ->
    show_agr_props($('#service_call_provider_agreement_id :selected'))


