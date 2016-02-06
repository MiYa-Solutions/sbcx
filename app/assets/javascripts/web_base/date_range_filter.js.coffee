class App.DateRangeFilter
  class: 'badge-inverse'
  label: =>
    @element.attr('name')
  constructor: (@element, @tableElem, @button) ->
    @init()

  select: @element

  @dateFormat: 'MM/DD/YYYY, h:mm:ss a'

  endDate: => if @element.val() != '' then @element.data('daterangepicker').endDate.format(DateRangeFilter.dateFormat) else ''
  startDate: => if @element.val() != '' then @element.data('daterangepicker').startDate.format(DateRangeFilter.dateFormat) else ''

  getVal: =>
    if @element.val() != ''
      "#{@startDate()} - #{@endDate()}"
    else
      null

  getText: =>
    @getVal()

  table: =>
    @theTable ||= @tableElem.DataTable()

  picker: =>
    @element.data('daterangepicker')

  setRange: (startDate, endDate) =>
    startMoment = moment(startDate, DateRangeFilter.dateFormat)
    endMoment = moment(endDate, DateRangeFilter.dateFormat)
    if startMoment.isValid()
      @picker().setStartDate(startMoment)
      @picker().setEndDate(endMoment)
      @element.val @picker().startDate.format(DateRangeFilter.dateFormat) + ' - ' + @picker().endDate.format(DateRangeFilter.dateFormat)

  clear: =>
    @element.trigger('cancel.daterangepicker')

  init: =>
    @element.daterangepicker(
      timePicker: true,
      timePickerIncrement: 30,
      autoUpdateInput: false,
      locale: {
        cancelLabel: 'Clear'
        format: 'MM/DD/YYYY h:mm A'
      },
      ranges: {
        'Today': [moment(), moment()],
        'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
        'Last 7 Days': [moment().subtract(6, 'days'), moment()],
        'Last 30 Days': [moment().subtract(29, 'days'), moment()],
        'This Month': [moment().startOf('month'), moment().endOf('month')],
        'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')]
      }
    )

    @element.on 'apply.daterangepicker', (ev, picker) =>
      @element.val picker.startDate.format(DateRangeFilter.dateFormat) + ' - ' + picker.endDate.format(DateRangeFilter.dateFormat)
      App.JobIndex.filterView.draw()
      @table().ajax.reload()
      return

    @element.on 'cancel.daterangepicker', (ev, picker) =>
      @element.val ''
      App.JobIndex.filterView.draw()
      @table().ajax.reload()
      return

    @button.live 'click', (e)=>
      @clear()
