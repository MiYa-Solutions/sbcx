jQuery ->
  $('select#agreement_type').change (event) ->
    agreement = $('#agreement_type option:selected').val()
    org_role = $('#agreement_type option:selected').data('organization')
    otherparty_role = $('#agreement_type option:selected').data('counterparty')

    # remove options
    $('#agreement_role_select option').remove()

    if org_role
      $('#agreement_role_select').append("<option value='organization'>#{org_role}</option>")

    if otherparty_role
      $('#agreement_role_select').append("<option value='counterparty'>#{otherparty_role}</option>")

