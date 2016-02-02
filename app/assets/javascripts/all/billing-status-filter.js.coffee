class App.BillingStatusFilter extends App.Filter

  placeholder_text: 'Select Billing Statuses'

  options = [
    {id: 4100, text: 'Pending'}
    {id: 4103, text: 'Overdue'}
    {id: 4104, text: 'Paid'}
    {id: 4109, text: 'Rejected'}
    {id: 4110, text: 'Partially Collected'}
    {id: 4102, text: 'Collected'}
    {id: 4114, text: 'In Process'}
    {id: 4113, text: 'Over Paid'}
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