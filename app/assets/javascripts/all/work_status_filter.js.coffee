class App.WorkStatusFilter extends App.Filter
  placeholder_text: 'Select Work Statuses'
  options = [
    {id: 2000, text: 'Pending'}
    {id: 2001, text: 'Dispatched'}
    {id: 2002, text: 'In Progress'}
    {id: 2003, text: 'Accepted'}
    {id: 2004, text: 'Rejected'}
    {id: 2005, text: 'Completed'}
    {id: 2006, text: 'Canceled'}
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