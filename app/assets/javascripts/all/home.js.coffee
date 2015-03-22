class App.OpenJobsFormater
  constractor: ->

  color_cells: (row, job)->
    $('td:eq(2)', row).addClass("job_status_#{job.status}")

  style: (row, job) ->
    this.color_cells(row, job)


$ ->
  $('#home-open-jobs').dataTable
    dom: "t<'row-fluid'<'span7'i><'span5'p>>"
    pagingType: 'simple'
    iDisplayLength: 5
    columnDefs: [
      'targets': [ 1,2,3 ]
      'sortable': false,
    ]
    order: [[0, 'desc']]
    aLengthMenu: [10, 25, 50]
    sPaginationType: "bootstrap"
    processing: true
    stateSave: true
    sAjaxSource: 'api/v1/service_calls.json'
    serverSide: true


    fnServerData: (sSource, aoData, fnCallback) ->
      aoData.push
        name: ":sSearch_5"
        value: "New|Open|Received New|Transferred|Passed On|Accepted|Rejcted"
      aoData.push
        name: "table_type"
        value: 'open_jobs'

      $.getJSON sSource, aoData, (json) ->
        fnCallback json

    columns: [
      {data: "ref_id"},
      {data: "name"},
      {data: "human_status"},
      {data: "human_work_status"}
    ]

    fnRowCallback: (nRow, job, iDisplayIndex) ->
      e = new App.OpenJobsFormater
      e.style(nRow, job)
