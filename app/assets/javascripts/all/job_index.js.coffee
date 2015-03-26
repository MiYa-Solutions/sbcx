class App.DataTableJobsFormater
  constractor: ->

  color_cells: (row, job)->
    @color_status_cell(row, job)
    @color_work_status_cell(row, job)


  style: (row, job) ->
    @color_cells(row, job)

  color_status_cell: (row, job)->
    $('.status', row).addClass("job_status_#{job.status}")

  color_work_status_cell: (row, job)->
    $('.work_status', row).addClass("job_work_status_#{job.work_status}")


$ ->
  $('a[data-toggle="tab"]').on 'shown.bs.tab', (e) ->
    localStorage.setItem('job_index/lastTab', $(e.target).attr('href'))

  last_tab = localStorage.getItem('job_index/lastTab')
  if last_tab
    $("a[href='#{last_tab}']").tab('show')
    $("a[href='#{last_tab}']").trigger('shown.bs.tab')
  else
    $("a[href='#newJobs']").tab('show')
    $("a[href='#newJobs']").trigger('shown.bs.tab')