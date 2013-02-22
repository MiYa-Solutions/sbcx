jQuery ->
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
    minTime: 7
    maxTime: 22
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



    #http://arshaw.com/fullcalendar/docs/event_ui/eventDrop/
    eventDrop: (event, dayDelta, minuteDelta, allDay, revertFunc) ->
      updateEvent event


    # http://arshaw.com/fullcalendar/docs/event_ui/eventResize/
    eventResize: (event, dayDelta, minuteDelta, revertFunc) ->
      updateEvent event


    # http://arshaw.com/fullcalendar/docs/mouse/eventClick/
    eventClick: (event, jsEvent, view) ->
      window.location.replace "/appointments/" + event.id + "/edit"


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



