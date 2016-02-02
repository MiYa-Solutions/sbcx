class App.Filter

  constructor: (@table, @select, @button) ->

    @button.live 'click', =>
      @clear()

    @select.on "change", =>
      @table.DataTable().ajax.reload()

    return

  getVal: =>
    @select.val()

  setVal: (val)=>
    @select.val(val).trigger('chosen:updated').trigger('change', [{selected: val}])

  setValNoReload: (val) =>
    @select.val(val).trigger('chosen:updated')


  clear: =>
    @setVal('')



