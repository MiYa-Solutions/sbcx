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
  obj.empty()
  $(agr_props).hide() if agr_props != null
  obj.append('<option></option>') if options.length > 1
  $.each options, (key, value) ->
    opt = $('<option></option>')
    opt.attr("value", value[1])
    opt.text(value[0])
    opt.data('props', value[2])
    obj.append(opt)
  show_agreement_select(obj)

show_agreement_select = (obj) ->
  obj.val($("##{obj.id} option:first").val()).selectmenu('refresh')
  obj_to_show = obj.parent('div')
  obj_to_show = obj_to_show.parent('div')
  obj_to_show.show(400)
  obj_to_show.prev('div.ui-block-a').show(400)
  show_agr_props(obj.find(":selected"))

hide_agreement_select = (obj) ->
  obj.empty()
  obj_to_hide = obj.parent('div')
  obj_to_hide = obj_to_hide.parent('div')
  obj_to_hide.hide(400)
  obj_to_hide.prev('div.ui-block-a').hide(400)

$(document).live "pageinit", ->
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
