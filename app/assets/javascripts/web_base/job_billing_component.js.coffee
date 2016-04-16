class JobBillingComponent
  customerComp: null
  contractorComp: null
  subconComp: null

  constructor: (@rootElement)->
    console.log('in component constructor')
    # get params from element
    @customer_account = @rootElement.data('customer-account')
    @billing_actions = @rootElement.data('billing-actions')
    @job_role = @rootElement.data('job-role')
    @subcon_account = @rootElement.data('subcon-account')
    @job_id = @rootElement.data('job-id')
    @org_id = @rootElement.data('org-id')
    @subcon_name = @rootElement.data('subcon-name')
    @customer_name = @rootElement.data('customer-name')
    @billing_actions = @rootElement.data('billing-actions')


    # get the data
    @data = @getData()

    @init()

    @draw()
    $(@rootElement.selector + ", form").submit ->
      $(this).find("input[type='submit']").prop('disabled',true)

  init: =>
    @container_id = 'job-billing-container'


  getEntriesForAccount: (account_id)=>
    res = $.grep @data, (e) ->
       return `e.account_id == account_id`
    res.sort (a, b)->
      b.id - b.id

  getOpenEntriesForAccount: (account_id)=>
    res = $.grep @getEntriesForAccount(account_id), (e) ->
      return e.events.length > 0
    res

  getDoneEntriesForAccount: (account_id)=>
    res = $.grep @getEntriesForAccount(account_id), (e) ->
      return e.events.length == 0
    res

  customerCompData: =>
    @rootElement.data('customer-comp')


  addEntry: (obj)=>
    @data.push(obj)

  container: =>
    $('#' + @container_id)

  draw: =>
    customer_comp_id = 'customer-billing-container'
    contractor_comp_id = 'contractor-billing-container'
    subcon_comp_id = 'subcon-billing-container'

    @rootElement.append(@drawContainer(@container_id))

    if @job_role == 'prov'
      @customerComp = new App.JobCustomerComponent(this, @rootElement.data('customer-comp'))
      @customerComp.draw()
    else
      @contractorComp = new App.JobContractorComponent(this, @rootElement.data('prov-comp'))
      @contractorComp.draw()


    if @rootElement.data('subcon-comp')
      @subconComp = new App.JobSubconComponent(this, @rootElement.data('subcon-comp'))
      @subconComp.draw()

#    $('#' + customer_comp_id).jobCustomerComponenet()

  drawContainer: (root_element)=>
    HandlebarsTemplates["jobs/job_billing_component"]({element_id: root_element})


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






