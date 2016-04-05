class App.JobSubconComponent extends App.BillingComponent

  template: "jobs/job_subcon_component"

  constructor: (@parent, @account_id)->
    @root_element = 'subcon-component'
    @job_id = @parent.job_id
    @org_id = @parent.org_id
    @subcon_name = @parent.subcon_name

  templateContext: =>
    context = super
    context.allow_collection = App.jobComponent.subconBillingAllowed()
    context


  name: =>
    @subcon_name

  status: =>
    'static status'



