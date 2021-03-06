class App.BillingComponent
  template: "you/forgot/to/specify/a/template in your subclass"

  constructor: (@parent, attr)->
    @job_id = @parent.job_id
    @org_id = @parent.org_id
    @account_id = attr.account
    @status = attr.status
    @name = attr.name
    @actions = attr.actions

  draw: =>
    html = HandlebarsTemplates[@template](@templateContext() )
    @parent.container().hide().append(html).fadeIn('slow')
    $("##{@root_element} [rel=tooltip]").tooltip()

  showBalance: =>
    App.jobComponent.work_status == 2005 || App.jobComponent.work_status == 2006

  balanceCents: =>
    @entries().sumObjProp('amount_cents')

  balanceHtml: =>
    res = 'N/A'
    if @showBalance()
      res =  "<span class='#{App.jobComponent.amountClass(@balanceCents())}'> #{App.jobComponent.formatMoney(@balanceCents())}</span>"
    return new Handlebars.SafeString(res)

  entries: =>
    @parent.getEntriesForAccount(@account_id)

  openEntries: =>
    @parent.getOpenEntriesForAccount(@account_id)

  closedEntris: =>
    @parent.getDoneEntriesForAccount(@account_id)

  showBalance: =>
    true

  templateContext: =>
    context = {}
    context.csrf_token = App.csrf_token()
    context.openEntriesCount = @openEntries().length
    context.open_entries = @openEntries()
    context.closed_entries = @closedEntris()
    entries = @entries()
    context.job_id = @job_id
    context.org_id = @org_id
    context.name = @name
    context.status = @status
    context.balance = @balanceHtml()
    context.balance_amount = @balanceCents() / 100
    context.element_id = @root_element
    context.actions = @actions
    context

