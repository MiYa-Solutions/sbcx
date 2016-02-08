class App.AffiliateFilter extends App.SingleStatusFilter

  placeholder_text: 'Select Affiliate'
  label: =>
    'Affiliate'

  constructor: (hash) ->
    super(hash)
    @customerFilter = hash['customer_filter']
    self = this

    @select.on "change", =>
      @customerFilter.clearNoReload(@getVal())


  setValue: (val)=>
    @customerFilter.clearNoReload(@getVal())
    super(val)

  clear: =>
    @customerFilter.clearNoReload(@getVal())
    super

