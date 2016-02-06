App.JobIndex = {}
App.JobIndex.filterView =
  filters: []
  rootElement: ''

  init: =>
    $.each App.JobIndex.filterView.filters, (i, f) =>
      $(f.select).on 'change apply.daterangepicker cancel.daterangepicker', =>
        App.JobIndex.filterView.draw()
        return
    return

  getHtml: (f, col) ->
    if f.getVal() != null && f.getVal() != ''
      return "<div class='span#{col}'><span class='badge #{f.class}'>#{f.label().titleize()} = #{f.getText()}</span></div>"
    else
      ''


  draw: =>
    res = []
    cols = 3
    col_span = 4
    res = res.filter(Boolean)
    rows = Math.floor(res.length / cols)
    rows = rows + 1 if (res.length % cols) > 0

    html = "<div class='row-fluid'>"
    row = 1
    filter_num = 0
    row_count = 1
    filters_w_values = App.JobIndex.filterView.getFiltersWithValue(App.JobIndex.filterView.filters)
    html = "<h6> Filters </h6>" + html unless filters_w_values.length == 0
    $.each filters_w_values, (i, f) =>
#      res = "<span class='label label-info'>" + f.label() + '</span>'if i == 0
      row = Math.floor( (i+1) / cols) + 1

      html = html + App.JobIndex.filterView.getHtml(f, col_span)
      if row != row_count
        row_count = row
        html = html + "</div><div class='row-fluid'>"

    html = html + '</div>'

    App.JobIndex.filterView.rootElement.html(html)


  getFiltersWithValue: (arr) =>

    res = []
    $.each arr, (i, f)=>
      if f.getVal() != null && f.getVal() != ''
        res.push f

    res