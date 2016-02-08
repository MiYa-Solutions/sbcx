class App.SingleStatusFilter extends App.Filter

  placeholder_text: 'Select Option'
  class: 'badge-warning'

  label: =>
    @select.attr('name')


  constructor: (hash) ->
    @select = hash['element']
    @table = hash['table']
    @button = hash['btn']

    @init()
    super

  init: =>
    @select.chosen
      placeholder_text_single: @placeholder_text