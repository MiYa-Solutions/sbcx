class App.JobContractorComponent extends App.BillingComponent

  template: "jobs/job_contractor_component"

  constructor: (@parent, @account_id)->
    super
    @root_element = 'contractor-component'
    @contractor_name = @parent.contractor_name

  templateContext: =>
    context = super
    context.allow_collection = @contractorBillingAllowed()
    context.allow_settle = @contractorSettleAllowed()
    context.customer_name = @customerName()
    context
    
#  draw: =>
#    super
#    if @contractorBillingAllowed()
#      comp = new App.CustomerCollectionComponent(@parent,@parent.customerCompData())
#      comp.draw()
      

  contractorBillingAllowed: =>
    @parent.billing_actions.indexOf('collect') > -1

  contractorSettleAllowed: =>
    @actions.indexOf('settle') > -1


  customerName: =>
    @parent.customer_name



