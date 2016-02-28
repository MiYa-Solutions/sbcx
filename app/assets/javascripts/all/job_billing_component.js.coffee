class JobBillingComponent
  constructor: (@rootElement)->
    console.log('in component constructor')
    # get params from element
    @customer_account = @rootElement.data('customer-account')
    @contractor_account = @rootElement.data('contractor-account')
    @subcon_account = @rootElement.data('subcon-account')
    @job_id = @rootElement.data('job-id')

    # get the data
    @data = @getData()

    @init()

    @draw()

  customerComp: null
  contractorComp: null
  subconComp: null


  init: =>
    @customerComp = new App.JobCustomerComponent(this, @customer_account)
    @container_id = 'job-billing-container'


  getEntriesForAccount: (account_id)=>
    $.grep @data, (e) ->
       return `e.account_id == account_id`

  addEntry: (obj)=>
    @data.push(obj)

  container: =>
    $('#' + @container_id)

  draw: =>
    customer_comp_id = 'customer-billing-container'
    contractor_comp_id = 'contractor-billing-container'
    subcon_comp_id = 'subcon-billing-container'

    console.log('in draw' + @data.toString())
    @rootElement.append(@drawContainer(@container_id))

    if @contractor_account
      $('#' + container_id).append(@drawContractorComp(contractor_comp_id))

#    $('#' + container_id).append(@drawCustomerComponent(customer_comp_id))
    @customerComp.draw()

    if @subcon_account
      $('#' + container_id).append(@drawSubconComponent(contractor_comp_id))

#    $('#' + customer_comp_id).jobCustomerComponenet()

  drawContainer: (root_element)=>
    HandlebarsTemplates["jobs/job_billing_component"]({element_id: root_element})

  drawContractorComp: (root_element)=>
    HandlebarsTemplates["jobs/job_contractor_component"]({element_id: root_element})

  drawSubconComponent: (root_element)=>
    HandlebarsTemplates["jobs/job_subcon_component"]({element_id: root_element})



  getData: =>
    [
      {
        id: '11454',
        account_id: '307'
        account_name: 'Stam Shem'
        created_at: 'Thu, 29 Oct 2015 10:45',
        ref_id: '5905',
        type: 'Check Payment',
        human_type: 'Check Payment',
        status: 'cleared',
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






