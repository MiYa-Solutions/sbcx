class JobComponent

  constructor: (@rootElement)->
    @billing_actions = @rootElement.data('billing-actions')
    @subcon_actions = @rootElement.data('subcon-actions')
    @actions = @rootElement.data('actions')
    @subcon_name = @rootElement.data('subcon-name')
    @customer_name = @rootElement.data('customer-name')
    @registerHandlebarsHelpers()
    return


  customerBillingAllowed: =>
    @billing_actions.indexOf('collect') > -1

  subconBillingAllowed: =>
    @subcon_actions.indexOf('settle') > -1

  registerHandlebarsHelpers: =>
    Handlebars.registerHelper('entryRow', (entry)=>
      res = "<tr id='accounting_entry_#{entry.id}'>"
      res = res + "<td id='entry_#{entry.id}_id'>#{entry.id}</td>"
      res = res + "<td id='entry_#{entry.id}_status'class=''>#{App.t.entry_status[entry.status]}</td>"
      res = res + "<td id='entry_#{entry.id}_created_at'>#{@formatDate(entry.created_at)}</td>"
      res = res + "<td id='entry_#{entry.id}_type'>#{entry.type}</td>"
      res = res + "<td id='entry_#{entry.id}_amount' class='#{@amountClass(entry.amount_cents)}'>#{@formatMoney(entry.amount_cents)}</td>"
      res = res + "<td id='entry_#{entry.id}_colelctor'>#{entry.collector}</td>"
      res = res + "<td id='entry_#{entry.id}_notes'>#{ if entry.notes == null then '' else entry.notes}</td>"
      res = res + "<td id='entry_#{entry.id}_actions' class='customer_entries_actions'>#{ @entryActionsHtml(entry)}</td>"

      res = res + "</tr>"
      return new Handlebars.SafeString(res)

    )

    Handlebars.registerHelper('translateEntryStatus', (status)=>
      App.t.entry_status[status]
    )

    Handlebars.registerHelper('translateCustomerStatus', (status)=>
      App.t.customer_status[status]
    )

    Handlebars.registerHelper('entryActionsHtml', (context)=>
      @entryActionsHtml(context)
    )

    Handlebars.registerHelper('formatDate', (date)=>
      @formatDate(date)
    )

    Handlebars.registerHelper('amountClass', (amount)=>
      @amountClass(amount)
    )

    Handlebars.registerHelper('formatMoney', (amount)=>
      @formatMoney(amount)
    )


  formatDate: (dateStr)=>
    moment(dateStr).format('ddd MMM DD YYYY, HH:mm:ss')

  entryActionsHtml: (entry)=>
    res = "<ul class='cheque_payment adj_entry_events unstyled'>"
    context = @entryFormContext(entry)
    for event in entry.events
      context.event = event
      res = res + HandlebarsTemplates["jobs/accouting_entry_form"](context)
    return new Handlebars.SafeString(res + "</ul>")

  formatMoney: (moneyStr)=>
    amount = parseInt(moneyStr) / 100
    accounting.formatMoney(amount)

  amountClass: (amount)=>
    if parseInt(amount) < 0 then 'red_balance' else 'green_balance'

  entryFormContext: (entry) =>
    entry.csrf_token = App.csrf_token()
    entry



$.fn.jobComponenet = (options)->
  settings = $.extend({
  }, options)
  obj = $.fn.jobComponenet.obj(this);
  return this

$.fn.jobComponenet.obj = (element)->
  if App.jobComponent == undefined
    App.jobComponent = new JobComponent(element)

  return App.jobComponent

