class App.CustomerFilter

  label: =>
    'Customer'
  class: 'badge-important'

  constructor: (hash) ->

    @input = hash['element']
    @table = hash['table']
    @button = hash['btn']
    @id_field = hash['id_field']
    @view = hash['view']

    @button.live 'click', =>
      @clear()

    @input.live "change", =>
      App.JobIndex.filterView.draw()
      @table.DataTable().ajax.reload()

    @input.live 'railsAutocomplete.select', (e, data) =>
      App.JobIndex.filterView.draw()
      @table.DataTable().ajax.reload()

#    @id_field.live "change", =>
#      @table.DataTable().ajax.reload()


    return

  show: =>
    $(@view).show()

  getText: =>
    @input.val()


  getVal: =>
    @id_field.val()

  setVal: (name, val)=>
    @input.val(name)
    @id_field.val(val)

  setValNoReload: (name, val) =>
    @setVal(name, val)

  clear: =>
    @setVal('', '')
    App.JobIndex.filterView.draw()
    @table.DataTable().ajax.reload()

  clearNoReload: (val)=>
    @setVal('', '')
    @input.attr('data-ref-id',val)
    return




