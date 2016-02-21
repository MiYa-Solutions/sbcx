class JobBillingComponent
  constructor: (@rootElement)->
    console.log('in component constructor')
    @customer_account = @rootElement.data('customer-account')
    @contractor_account = @rootElement.data('contractor-account')
    @subcon_account = @rootElement.data('subcon-account')
    @job_id = @rootElement.data('job-id')

    @data = @getData()

    @draw()

  draw: =>
    console.log('in draw' + @data.toString())
    container = HandlebarsTemplates["jobs/job_billing_component"]()
    customer_component = HandlebarsTemplates["jobs/job_customer_component"]({entries: @data})
    html = $(container).append((customer_component))
    @rootElement.append(html)

  getData: =>
    [
      {
        id: '11454',
        created_at: 'Thu, 29 Oct 2015 10:45',
        ref_id: '5905',
        type: 'Check Payment',
        human_type: 'Check Payment',
        status: 'Test',
        human_status: 'Test',
        amount: '$1',
        balance: '$1',
        actions: ['accept'],
        notes: 'static notes',
        collector_name: 'static collector'
      }
    ]

$.fn.jobBillingComponenet = (options)->
  console.log('in plugin')
  settings = $.extend({
  }, options)
  obj = $.fn.jobBillingComponenet.obj(this);
  return this

$.fn.jobBillingComponenet.obj = (element)->
  if App.jobBillingComponent == undefined
    App.jobBillingComponent = new JobBillingComponent(element)

  return App.jobBillingComponent




