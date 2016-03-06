class App.BillingComponent
  template: "you/forgot/to/specify/a/template in your subclass"

  constructor: (@parent, @account_id)->
    @job_id = @parent.job_id
    @org_id = @parent.org_id

  draw: =>
    html = HandlebarsTemplates[@template](@templateContext() )
    @parent.container().hide().append(html).fadeIn('slow')
    $("##{@root_element} [rel=tooltip]").tooltip()

  templateContext: =>
    alert("BillingComponent: You forgot to define a templateContext method")

  balance: =>
    amount_cents = @entries().sumObjProp('amount_cents')
    Handlebars.SafeString "<span class='#{App.jobComponent.amountClass(amount_cents)}'> #{App.jobComponent.formatMoney(amount_cents)}</span>"

  entries: =>
    @parent.getEntriesForAccount(@account_id)

  openEntries: =>
    @parent.getOpenEntriesForAccount(@account_id)

  closedEntris: =>
    @parent.getDoneEntriesForAccount(@account_id)

