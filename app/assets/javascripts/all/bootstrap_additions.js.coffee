$('.popover').popover()
$(".collapse").collapse('toggle')
$('.typeahead').typeahead()
$(".tooltip").tooltip()
$("a[rel=tooltip]").tooltip()

jQuery ->
  $('.carousel').carousel()
  $("a[rel=popover]").popover()
  $(".tooltip").tooltip()
  $("a[rel=tooltip]").tooltip()
  $('.best_in_place').best_in_place()


  $(".datepicker").datepicker
    dateFormat:"M, dd, yy",
    showButtonPanel: false,
    changeMonth:true,
    changeYear:true

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
    changeMonth: true
    changeYear: true




  $(".accordion .head").click(->
    $(this).next().toggle "slow"
    false
  ).next().hide()
