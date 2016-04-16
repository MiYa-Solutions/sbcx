$(document).live "pageinit", ->
  $(".mobi-datetime").mobiscroll().datetime()
  $(".mobi-dateonly").mobiscroll().date()
  $(".mobi-timeonly").mobiscroll().time()

  clear_btn = $("<a href='' class='ui-btn-inner input-clear' data-role='button'>X</a>")
  $(".mobi-datetime").before(clear_btn)
  $(".mobi-dateonly").before(clear_btn)
  $(".mobi-timeonly").before(clear_btn)

  $('.input-clear').click ->
    $(this).next().val('')



