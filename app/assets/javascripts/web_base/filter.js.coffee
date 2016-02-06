class App.Filter

  label: =>
    'Filter'

  constructor: (hash) ->
    class: ''
    @select = hash['element']
    @table = hash['table']
    @button = hash['btn']


    @button.live 'click', =>
      @clear()

    @select.on "change", =>
      App.JobIndex.filterView.draw()
      @table.DataTable().ajax.reload()

    return

  getText: =>
    txt = ''
    selected = $(@select.selector + ' option:selected')
#    $(@select.selector + ' option:selected').text()
    selected.each (i, opt) =>
      txt = txt + $(opt).text()
      if i < selected.length - 1
        txt = txt + ' | '

    txt


  getVal: =>
    @select.val()

  setVal: (val)=>
    @select.val(val).trigger('chosen:updated').trigger('change', [{selected: val}])

  setValNoReload: (val) =>
    @select.val(val).trigger('chosen:updated')

  clear: =>
    @setVal('')



