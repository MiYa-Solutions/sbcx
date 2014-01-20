simple_form_obj_to_show = (obj_changed, obj_to_hide) ->
  element = $(obj_to_hide).parent('div').parent('div')
  if obj_changed.val() == 'other'
    element.show(400)
    element.removeClass('hidden')
  else
    element.hide(400)
    element.addClass('hidden')

jQuery ->
  simple_form_obj_to_show($('#user_organization_attributes_industry'),
    $('#user_organization_attributes_other_industry'))
  simple_form_obj_to_show($('#organization_industry'), $('#organization_other_industry'))

  $('#user_organization_attributes_industry').change ->
    simple_form_obj_to_show($('#user_organization_attributes_industry'),
      $('#user_organization_attributes_other_industry'))
  $('#organization_industry').change ->
    simple_form_obj_to_show($('#organization_industry'), $('#organization_other_industry'))
  $('#affiliate_industry').change ->
    simple_form_obj_to_show($('#affiliate_industry'), $('#affiliate_other_industry'))

