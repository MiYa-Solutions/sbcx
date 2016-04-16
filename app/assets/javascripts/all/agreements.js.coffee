jQuery ->
  $('.best_in_place.track_change').bind("ajax:success", ->
    $(this).addClass('changed')
    $('#agreement_accept_btn').remove()
  )