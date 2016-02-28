class App.JobCustomerComponent

  constructor: (@parent, @account_id)->
    @root_element = 'customer-component'
#    Handlebars.partials['accounting_entry_form'] = HandlebarsTemplates["partials/accounting_entry_form"]()


  draw: =>
    context = @buildTemplateContext()
    html = HandlebarsTemplates["jobs/job_customer_component"](context )
    @parent.container().append(html)
    $("##{@root_element} [rel=tooltip]").tooltip()

  customer: =>
    {
      name: @customerName()
      status: @status()
      balance: @balance()
      entries: @entries()

    }

  buildTemplateContext: =>
    context = @customer()
    context.element_id = @root_element
    context.allow_collection = App.jobComponent.customerBillingAllowed()
    context.csrf_token = $('meta[name="csrf-token"]').attr('content')
    context.job_id = 5846
    context.org_id = 12
    context

  customerName: =>
    'Static Customer Name'

  balance: =>
    '$1,045.78'

  entries: =>
    @parent.getEntriesForAccount(@account_id)

  status: =>
    'static status'



