#originalLeave = $.fn.popover.Constructor::leave
#$.fn.popover.Constructor::leave = (obj) ->
#  self = (if obj instanceof @constructor then obj else $(obj.currentTarget)[@type](@getDelegateOptions()).data("bs." + @type))
#  container = undefined
#  timeout = undefined
#  originalLeave.call this, obj
#  if obj.currentTarget
#    container = $(obj.currentTarget).siblings(".popover")
#    timeout = self.timeout
#    container.one "mouseenter", ->
#
#      #We entered the actual popover – call off the dogs
#      clearTimeout timeout
#
#      #Let's monitor popover content instead
#      container.one "mouseleave", ->
#        $.fn.popover.Constructor::leave.call self, self
Date::addHours = (h) ->
  @setHours @getHours() + h
  this

class EventView
  constructor: (@event) ->

  title: ->
    "<span class='text-info'><strong>#{this.event.title}</strong></span>"

  content: ->
    "<small>" + @event.start.toDateString() + " " + @event.start.toLocaleTimeString() + " - " +
    @event.end.toDateString() + " " +
    @event.end.toLocaleTimeString() + "</small><br><br>" +
    @event.description + "<br>"


jQuery ->
  $('#job_appointments').on 'shown.bs.tab', ->
    $("#calendar").fullCalendar('render')

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
      $('#appointment_starts_at_date_text').val(($.format.date(start, "E MMM, dd yyyy")))
      $('#appointment_starts_at_time_text').val($.format.date(start, "H:mm"))
#      $('#appointment_starts_at_time_text').timepicker
#        hour: start.getHours()
#        minute: start.getMinutes()

      $('#appointment_ends_at_date_text').val(($.format.date(end, "E MMM, dd yyyy")))
      $('#appointment_ends_at_time_text').val(($.format.date(end, "H:mm")))




  #http://arshaw.com/fullcalendar/docs/event_ui/eventDrop/
    eventDrop: (event, dayDelta, minuteDelta, allDay, revertFunc) ->
      updateEvent event


  # http://arshaw.com/fullcalendar/docs/event_ui/eventResize/
    eventResize: (event, dayDelta, minuteDelta, revertFunc) ->
      updateEvent event


  # http://arshaw.com/fullcalendar/docs/mouse/eventClick/
    eventMouseover: (event, jsEvent, view) ->
      event_view = new EventView(event)
      p = $(this).popover(
        selector: this.selector
        delay: {show: 50, hide: 500}
        content: event_view.content()
        placement: 'bottom'
        title: event_view.title()
        trigger: 'hover'
      ).on "shown.bs.popover", (e) ->
        popover = $(this)
        $(this).parent().find("div.popover .close").on "click", (e) ->
          popover.popover('toggle')

      p.popover('toggle')


    eventClick: (event, jsEvent, view) ->
      window.location.replace '/appointments/' + event.id + '/edit'

    eventMouseout: (event, jsEvent, view) ->

    eventRender: (event, element) ->

  updateEvent = (the_event) ->
    $.ajax
      type: "put"
      dataType: "script"
      url: "/appointments/" + the_event.id
      context: this

      data:
        appointment:
          title: the_event.title
          starts_at: "" + the_event.start
          ends_at: "" + the_event.end
          description: the_event.description

      complete: (response) ->

      success: (response) ->
        $(this).append("<span class='green'>Saved!</span>").show().fadeOut(2000)

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

  appointment_link = (app) ->
    url = "/appointments/" + app.id + "/edit"

    "<a href=#{url}>Click Here</a>"


  $('#appointment_starts_at_date_text').on 'change', (e) ->
    date = new Date($(this).val())
    $('#appointment_ends_at_date_text').val($.format.date(date, "E MMM, dd yyyy"))

  $('#appointment_starts_at_time_text').on 'change', (e) ->
    time = new Date($('#appointment_starts_at_date_text').val() + " " + $(this).val())
    $('#appointment_ends_at_time_text').val($.format.date(time.addHours(1), "H:mm"))

  if $('#appointment_starts_at_date_text').val() == ''
    $('#appointment_starts_at_date_text').val(($.format.date(new Date(), "E MMM, dd yyyy")))
    $('#appointment_starts_at_time_text').val(($.format.date(new Date(), "H:mm")))

  if $('#appointment_ends_at_date_text').val() == ''
    $('#appointment_ends_at_date_text').val(($.format.date(new Date(), "E MMM, dd yyyy")))
    $('#appointment_ends_at_time_text').val(($.format.date(new Date().addHours(1), "H:mm")))



