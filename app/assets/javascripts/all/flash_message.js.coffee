$ ->
  flashCallback = ->
    $(".alert-success, .alert-notice").fadeOut()
  $(".alert-success, .alert-notice").bind 'click', (ev) =>
    $(".alert-success, .alert-notice").fadeOut(3000)
  setTimeout flashCallback, 4000