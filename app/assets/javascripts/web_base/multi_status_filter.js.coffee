class App.MultiStatusFilter extends App.Filter

  placeholder_text: 'Select Statuses'

  options: []
  class: 'badge-info'
  label: =>
    @select.attr('name')


  constructor: (hash) ->
    @select = hash['element']
    @table = hash['table']
    @button = hash['btn']

    @init()
    super

  init: =>

    for opt in @options
      option = new Option(opt.text, opt.id)
      @select.append(option)

    @select.chosen
      placeholder_text_multiple: @placeholder_text