class App.WorkStatusFilter extends App.Filter
  placeholder_text: 'Select Work Statuses'
  label: =>
    'Work Status'
  options = [
    {id: 2000, text: 'Pending'}
    {id: 2001, text: 'Dispatched'}
    {id: 2002, text: 'In Progress'}
    {id: 2003, text: 'Accepted'}
    {id: 2004, text: 'Rejected'}
    {id: 2005, text: 'Completed'}
    {id: 2006, text: 'Canceled'}
  ]

  constructor: (hash) ->
    @select = hash['element']
    @table = hash['table']
    @button = hash['btn']

    @init()
    super

  init: =>

    for opt in options
      option = new Option(opt.text, opt.id)
      @select.append(option)

    @select.chosen
      placeholder_text_multiple: this.placeholder_text