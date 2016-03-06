class App.JobCustomerComponent extends App.BillingComponent

  template: "jobs/job_customer_component"

  constructor: (@parent, @account_id)->
    @root_element = 'customer-component'
    @job_id = @parent.job_id
    @org_id = @parent.org_id
    @customer_name = @parent.customer_name

#    Handlebars.partials['accounting_entry_form'] = HandlebarsTemplates["partials/accounting_entry_form"]()

  templateContext: =>
    context = @customer()
    context.element_id = @root_element
    context.allow_collection = App.jobComponent.customerBillingAllowed()
    context.csrf_token = $('meta[name="csrf-token"]').attr('content')
    context.job_id = @job_id
    context.org_id = @org_id
    context


  customer: =>
    {
      name: @name()
      status: @status()
      balance: @balance()
      entries: @entries()
      open_entries: @openEntries()
      closed_entries: @closedEntris()

    }

  name: =>
    @customer_name


  customerName: =>
    'Static Customer Name'

  status: =>
    'static status'



