App.JobIndex = {}
App.JobIndex.filterView =
  filters: []
  rootElement: ''
  table: null

  getHtml: (f, col) ->
    if f.getVal() != null && f.getVal() != ''
      return "<div class='span#{col} filter' data-filter-view='#{f.view}'><span class='badge #{f.class}'>#{f.label().titleize()} = #{f.getText()}</span></div>"
    else
      ''


  draw: =>
      html = App.JobIndex.filterView.getFiltersHtml()
      App.JobIndex.filterView.rootElement.html(html)
      App.JobIndex.filterView.setupClearAll()
      App.JobIndex.filterView.setupFilterClickEvent()


  remove: =>
    App.JobIndex.filterView.rootElement.html('')

  getFiltersWithValue: (arr) =>
    res = []
    $.each arr, (i, f)=>
      if f.getVal() != null && f.getVal() != ''
        res.push f

    res

  getFiltersHtml: =>
    filters_w_values = App.JobIndex.filterView.getFiltersWithValue(App.JobIndex.filterView.filters)
    unless filters_w_values.length == 0
      cols = 3
      col_span = 4

      html = HandlebarsTemplates['jobs/filters_view']()

      row = 1
      filter_num = 0
      row_count = 1


      $.each filters_w_values, (i, f) =>
#      res = "<span class='label label-info'>" + f.label() + '</span>'if i == 0
        row = Math.floor((i + 1) / cols) + 1

        html = html + App.JobIndex.filterView.getHtml(f, col_span)
        if row != row_count
          row_count = row
          html = html + "</div><div class='row-fluid'>"

      html = html + '</div>'

  setupClearAll: =>
    $('#clear-all-filters').click =>
      $.each App.JobIndex.filterView.filters, (i, f)->
        f.setValNoReload('')
      App.JobIndex.filterView.remove()
      App.JobIndex.filterView.table.ajax.reload()
    return

  setupFilterClickEvent: =>
    $('#filters div.filter').live 'click',  (e)->
      $($(@).data('filter-view')).collapse('toggle')





