$(document).live "pageinit", ->
  $(".mobi-datetime").mobiscroll().datetime()
  $(".mobi-dateonly").mobiscroll().date()
  $(".mobi-timeonly").mobiscroll().time()