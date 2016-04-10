class App.JobCustomerComponent extends App.BillingComponent

  template: "jobs/job_customer_component"

  constructor: (@parent, attr)->
    super
    @root_element = 'customer-component'
    @job_id = @parent.job_id
    @org_id = @parent.org_id
    @customer_name = @parent.customer_name

  templateContext: =>
    context = super
#    context.allow_collection = App.jobComponent.customerBillingAllowed()
    context.allow_collection = @allowCollection()
    context

  allowCollection: =>
    @actions.indexOf('collect') > -1

  showBalance: =>
    App.jobComponent.work_status == 2005 || App.jobComponent.work_status == 2006

  name: =>
    @customer_name




