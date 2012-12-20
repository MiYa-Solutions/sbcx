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


