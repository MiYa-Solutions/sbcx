jQuery ->
  $('#user_organization_attributes_industry').change ->
    element = $('#user_organization_attributes_other_industry').parent('div').parent('div')
    if this.value == 'other'
      element.show(400)
      element.removeClass('hidden')
    else
      element.hide(400)
      element.addClass('hidden')
