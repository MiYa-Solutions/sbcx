class App.SingleStatusFilter extends App.Filter

  placeholder_text: 'Select Option'
  class: 'badge-warning'

  label: =>
    @select.attr('name')


  constructor: (@table, @select, @button) ->
    @init()
    super

  init: =>
    @select.chosen
      placeholder_text_single: @placeholder_text