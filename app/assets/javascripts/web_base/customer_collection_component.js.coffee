class App.CustomerCollectionComponent extends App.BillingComponent

  template: "jobs/customer_collection_component"

  constructor: (@parent, attr)->
    super
    @root_element = 'customer-collection'


#  templateContext: =>
#    context = super


