class App.JobSubconComponent extends App.BillingComponent

  template: "jobs/job_subcon_component"

  constructor: (@parent, @account_id)->
    super
    @root_element = 'subcon-component'
    @subcon_name = @parent.subcon_name

  templateContext: =>
    context = super
    context.allow_collection = @subconBillingAllowed()
    context.allow_settle = @subconSettleAllowed()
    context.customer_name = @customerName()
    context

  showBalance: =>
    App.jobComponent.work_status == 2005 || App.jobComponent.work_status == 2006

  subconBillingAllowed: =>
    @parent.billing_actions.indexOf('collect') > -1

  subconSettleAllowed: =>
    @actions.indexOf('settle') > -1


  name: =>
    @subcon_name

  customerName: =>
    @parent.customer_name



