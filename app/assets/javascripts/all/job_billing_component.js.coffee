class JobBillingComponent
  constructor: (@rootElement)->
    console.log('in component constructor')
    # get params from element
    @customer_account = @rootElement.data('customer-account')
    @contractor_account = @rootElement.data('contractor-account')
    @subcon_account = @rootElement.data('subcon-account')
    @job_id = @rootElement.data('job-id')
    @org_id = @rootElement.data('org-id')
    @subcon_name = @rootElement.data('subcon-name')
    @customer_name = @rootElement.data('customer-name')


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
    res = $.grep @data, (e) ->
       return `e.account_id == account_id`
    res

  getOpenEntriesForAccount: (account_id)=>
    res = $.grep @getEntriesForAccount(account_id), (e) ->
      return e.events.length > 0
    res

  getDoneEntriesForAccount: (account_id)=>
    res = $.grep @getEntriesForAccount(account_id), (e) ->
      return e.events.length == 0
    res




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
      $('#' + @container_id).append(@drawContractorComp(contractor_comp_id))

#    $('#' + container_id).append(@drawCustomerComponent(customer_comp_id))
    @customerComp.draw()

    if @subcon_account
      @subconComp = new App.JobSubconComponent(this, @subcon_account)
      @subconComp.draw()

#    $('#' + customer_comp_id).jobCustomerComponenet()

  drawContainer: (root_element)=>
    HandlebarsTemplates["jobs/job_billing_component"]({element_id: root_element})

  drawContractorComp: (root_element)=>
    HandlebarsTemplates["jobs/job_contractor_component"]({element_id: root_element})



  getData: =>
    @rootElement.data('entries')

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






