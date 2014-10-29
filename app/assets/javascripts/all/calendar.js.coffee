jQuery ->
  $('#job_appointments').on 'shown.bs.tab', ->
    $("#calendar").fullCalendar('render')

  date = new Date()
  d = date.getDate()
  m = date.getMonth()
  y = date.getFullYear()

  $("#calendar").fullCalendar
    editable: true
    header:
      left: "prev,next today"
      center: "title"
      right: "month,agendaWeek,agendaDay"

    defaultView: "agendaWeek"
    height: 500
    slotMinutes: 30
    minTime: 0
    maxTime: 24
    firstHour: 8
    loading: (bool) ->
      if bool
        $("#loading").show()
      else
        $("#loading").hide()

    selectable: true
    selectHelper: true

  # a future calendar might have many sources.
    eventSources: [
      url: "/appointments"
      ignoreTimezone: false
    ]
    timeFormat: "h:mm t{ - h:mm t} "
    dragOpacity: "0.5"
    select: (start, end, allDay) ->
      endtime = start.toDateString()
      starttime = end.toDateString()
      alert(starttime + ' - ' + endtime)


  #http://arshaw.com/fullcalendar/docs/event_ui/eventDrop/
    eventDrop: (event, dayDelta, minuteDelta, allDay, revertFunc) ->
      updateEvent event


  # http://arshaw.com/fullcalendar/docs/event_ui/eventResize/
    eventResize: (event, dayDelta, minuteDelta, revertFunc) ->
      updateEvent event


  # http://arshaw.com/fullcalendar/docs/mouse/eventClick/
    eventClick: (event, jsEvent, view) ->
      window.location.replace "/appointments/" + event.id + "/edit"

    eventRender: (event, element) ->


    eventMouseover: (event, jsEvent, view) ->
      p = $(this).popover(
        content: "<small>" + event.start.toDateString() + " " + event.start.toLocaleTimeString() + " - " + event.end.toDateString() + " " + event.end.toLocaleTimeString()+ "</small><br><br>" + event.description
        placement: 'bottom'
        title: event.title
      )

      p.popover('show')

    eventMouseout: (event, jsEvent, view) ->
      $(this).popover('hide')


  updateEvent = (the_event) ->
    $.ajax
      type: "put"
      dataType: "script"
      url: "/appointments/" + the_event.id

      data:
        appointment:
          title: the_event.title
          starts_at: "" + the_event.start
          ends_at: "" + the_event.end
          description: the_event.description

      complete: (response) ->

  addEvent = (the_event) ->
    $.ajax
      type: "post"
      url: "/appointments/"
      dataType: "script"
      data:
        appointment:
          title: the_event.title
          starts_at: "" + the_event.start
          ends_at: "" + the_event.end
          description: the_event.description

      complete: (response) ->



