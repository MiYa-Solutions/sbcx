$('.popover').popover()
$(".collapse").collapse('toggle')
$('.typeahead').typeahead()


jQuery ->
  $(".tooltip").tooltip()
  $("a[rel=tooltip]").tooltip()
  $("img[rel=tooltip]").tooltip()
  $("input[rel=tooltip]").tooltip()

  $("input.login_hint").ezpz_hint()

  $('.carousel').carousel()
  $("a[rel=popover]").popover()
  $(".tooltip").tooltip()
  $("a[rel=tooltip]").tooltip()
  $('.best_in_place').best_in_place()

  $.datepicker.setDefaults
    dateFormat: "D M, dd yy"
    showButtonPanel: true

  $(".datepicker").datepicker
    formatDate: "D M, dd yy"
    showButtonPanel: false
    changeMonth: true
    changeYear: true

  $(".datetimepicker").datetimepicker
    formatDate: "D M, dd yy"
    timeFormat: "hh:mm tt"
    stepHour: 1,
    stepMinute: 1
#    controlType: 'select'

  $(".timepicker").timepicker
    timeFormat: "HH:mm"
    stepHour: 1,
    stepMinute: 1
#    controlType: 'select'


  $(".datepicker2").datepicker
    dateFormat: "yy-mm-dd"
    dateFormat: ""
    changeMonth: true
    changeYear: true


  $(".accordion .head").click(->
    $(this).next().toggle "slow"
    false
  ).next().hide()


