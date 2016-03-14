class App.JobCustomerComponent extends App.BillingComponent

  template: "jobs/job_customer_component"

  constructor: (@parent, @account_id)->
    @root_element = 'customer-component'
    @job_id = @parent.job_id
    @org_id = @parent.org_id
    @customer_name = @parent.customer_name

  templateContext: =>
    context = super
    context.allow_collection = App.jobComponent.customerBillingAllowed()
    context

  name: =>
    @customer_name


  customerName: =>
    'Static Customer Name'

  status: =>
    'static status'



