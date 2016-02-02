class App.JobStatusFilter extends App.Filter

  placeholder_text: 'Select Statuses'

  options = [
    {id: 0, text: 'New'}
    {id: 1, text: 'Open'}
    {id: 2, text: 'Transferred'}
    {id: 3, text: 'Closed'}
    {id: 4, text: 'Canceled'}
    {id: 1201, text: 'Accepted'}
    {id: 1202, text: 'Rejected'}
  ]


  constructor: (@table, @select, @button) ->
    @init()
    super

  init: =>

    for opt in options
      option = new Option(opt.text, opt.id)
      @select.append(option)

    @select.chosen
      placeholder_text_multiple: this.placeholder_text