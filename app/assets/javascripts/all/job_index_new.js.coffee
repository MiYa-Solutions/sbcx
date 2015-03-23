$ ->
  $('#new-jobs').dataTable
    dom: "t<'row-fluid'<'span7'i><'span5'p>>"
    pagingType: 'simple'
    iDisplayLength: 5
    columnDefs: [
      'targets': [ 1,2,3, 4, 5,6 ]
      'sortable': false,
    ]
    order: [[0, 'desc']]
    aLengthMenu: [10, 25, 50]
    sPaginationType: "bootstrap"
    processing: true
    stateSave: true
    sAjaxSource: 'api/v1/service_calls.json'
    serverSide: true
    deferLoading: 0


    fnServerData: (sSource, aoData, fnCallback) ->
      aoData.push
        name: ":sSearch_5"
        value: "New|Open|Received New|Transferred|Passed On|Accepted|Rejcted"
      aoData.push
        name: "table_type"
        value: 'new_jobs'

      $.getJSON sSource, aoData, (json) ->
        fnCallback json

    columns: [
      {data: "ref_id", className: 'ref_id', name: 'ref_id'},
      {data: "human_status", className: 'status', name: 'human_status_test'},
      {data: "human_name", className: 'name', name: 'name'},
      {data: "customer", className: 'customer', name: 'customer'},
      {data: "human_work_status", className: 'work_status', name: 'work_status'},
      {data: "scheduled_for", className: 'scheduled_for', name: 'scheduled_for'},
      {data: "contractor", className: 'contractor', name: 'contractor'}

    ]

    fnRowCallback: (nRow, job, iDisplayIndex) ->
      e = new App.DataTableJobsFormater
      e.style(nRow, job)

  $('#new-transferred-jobs').dataTable
    dom: "t<'row-fluid'<'span7'i><'span5'p>>"
    pagingType: 'simple'
    iDisplayLength: 5
    columnDefs: [
      'targets': [ 1,2,3, 4, 5,6,7 ]
      'sortable': false,
    ]
    order: [[0, 'desc']]
    aLengthMenu: [10, 25, 50]
    sPaginationType: "bootstrap"
    processing: true
    stateSave: true
    sAjaxSource: 'api/v1/service_calls.json'
    serverSide: true
    deferLoading: 0


    fnServerData: (sSource, aoData, fnCallback) ->
      aoData.push
        name: ":sSearch_5"
        value: "New|Open|Received New|Transferred|Passed On|Accepted|Rejcted"
      aoData.push
        name: "table_type"
        value: 'new_transferred_jobs'

      $.getJSON sSource, aoData, (json) ->
        fnCallback json

    columns: [
      {data: "ref_id", className: 'ref_id', name: 'ref_id'},
      {data: "human_status", className: 'status', name: 'human_status_test'},
      {data: "human_name", className: 'name', name: 'name'},
      {data: "customer", className: 'customer', name: 'customer'},
      {data: "human_work_status", className: 'work_status', name: 'work_status'},
      {data: "scheduled_for", className: 'scheduled_for', name: 'scheduled_for'},
      {data: "contractor", className: 'contractor', name: 'contractor'},
      {data: "subcontractor", className: 'subcontractor', name: 'subcontractor'}
    ]

    fnRowCallback: (nRow, job, iDisplayIndex) ->
      e = new App.DataTableJobsFormater
      e.style(nRow, job)

  $("a[href='#newJobs']").one 'shown.bs.tab', ->
    $('#new-jobs').dataTable().api().ajax.reload()
    $('#new-transferred-jobs').dataTable().api().ajax.reload()

  if $('#newJobs').is(':visible')
    $('#new-jobs').dataTable().api().ajax.reload()
    $('#new-transferred-jobs').dataTable().api().ajax.reload()



