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
    dateFormat: "mm/dd/yyyy"
    showButtonPanel: true

  $(".datepicker").datepicker
    dateFormat: "mm/dd/yyyy",
    showButtonPanel: false,
    changeMonth: true,
    changeYear: true

  $(".datetimepicker").datetimepicker
    timeFormat: "hh:mm tt"
    stepHour: 1,
    stepMinute: 1

  $(".timepicker").timepicker
    timeFormat: "HH:mm"
    stepHour: 1,
    stepMinute: 1


  $(".datepicker2").datepicker
    dateFormat: "yy-mm-dd"
    dateFormat: ""
    changeMonth: true
    changeYear: true


  $(".accordion .head").click(->
    $(this).next().toggle "slow"
    false
  ).next().hide()
