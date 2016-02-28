class App.JobComponent
  constructor: (@rootElement)->
    @billing_actions = @rootElement.data('billing-actions')
    @actions = @rootElement.data('actions')

  customerBillingAllowed: =>
    @billing_actions.indexOf('collect') > -1

$.fn.jobComponenet = (options)->
  settings = $.extend({
  }, options)
  obj = $.fn.jobComponenet.obj(this);
  return this

$.fn.jobComponenet.obj = (element)->
  if App.jobComponent == undefined
    App.jobComponent = new App.JobComponent(element)

  return App.jobComponent

