class App.JobSubconComponent extends App.BillingComponent

  template: "jobs/job_subcon_component"

  constructor: (@parent, @account_id)->
    @root_element = 'subcon-component'
    @job_id = @parent.job_id
    @org_id = @parent.org_id
    @subcon_name = @parent.subcon_name

  templateContext: =>
    context = @subcon()
    context.element_id = @root_element
    context.allow_collection = App.jobComponent.subconBillingAllowed()
    context.csrf_token = $('meta[name="csrf-token"]').attr('content')
    context.job_id = @job_id
    context.org_id = @org_id
    context

  subcon: =>
    {
      name: @name()
      status: @status()
      balance: @balance()
      entries: @entries()

    }

  name: =>
    @subcon_name

  status: =>
    'static status'



