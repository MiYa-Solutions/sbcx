jQuery ->
  old_val = $('#add_part').val()
  $('#spinner').toggle()
  $('#new-bom-button').click (e) ->
    e.preventDefault()

  $('#new_bom').bind("ajax:before", ->
    $('#spinner').toggle()
    $('#add_part').val("Wait...")
  )

  $('#new_bom').bind("ajax:complete", ->
    $('#spinner').toggle()
    $('#add_part').val(old_val)
  )

  $('#new_bom').bind("ajax:success", ->
    $("#ajax-msg").html("<span class='green'>Saved!</span>").show().fadeOut(2000)
  )

  $('#bom_material_name').bind('railsAutocomplete.select', (event, data) ->
    $('#bom_cost').val(data["item"]["cost_cents"] / 100.0)
    $('#bom_price').val(data["item"]["price_cents"] / 100.0)
  )

  $('#bom_buyer_id').change (e) ->
    type = $('#bom_buyer_id option:selected').data('type')
    $('#bom_buyer_type').val(type)



