jQuery ->
  $('#customer-jobs').dataTable
    dom: "t<'row-fluid'<'span7'i><'span5'p>>"
    pagingType: 'simple'
    iDisplayLength: 5
    aoColumnDefs: [{ 'bSortable': false, 'aTargets': [ 1,2,3,4 ] }]
    order: [[0, 'desc']]
#   aLengthMenu: [10, 25, 50, 100, 200, 300]
    sPaginationType: "bootstrap"
    processing: true
    stateSave: true
    serverSide: true
    sAjaxSource: '/api/v1/service_calls.json'

    fnServerData: (sSource, aoData, fnCallback) ->
      aoData.push
        name: "from_date"
        value: $('#from-date').val()
      aoData.push
        name: "to_date"
        value: $('#to-date').val()

      aoData.push
        name: "customer_id"
        value: $('#customer-jobs').data('customer-id')
      aoData.push
        name: "table_type"
        value: 'customer_active_jobs'
      aoData.push
        name: "sSearch_5"
        value: 'New|Open|Transferred|Passed On|Accepted|Rejcted'

      $.getJSON sSource, aoData, (json) ->
        fnCallback json

    columns: [
      {data: "ref_id", name: 'ref_id', className: 'ref_id'},
      {data: "created_at", name: 'created_at', className: 'created_at'},
      {data: "human_name", name: 'name', className: 'name'},
      {data: "human_work_status", name: 'work_status', className: 'work_status' },
      {data: "total_price", name: 'total_price', className: 'total_price' }
    ]

    fnRowCallback: (nRow, job, iDisplayIndex) ->
      e = new App.DataTableJobsFormater
      e.style(nRow, job)

  $('#customer-overdue-jobs').dataTable
    dom: "t<'row-fluid'<'span7'i><'span5'p>>"
    pagingType: 'simple'
    iDisplayLength: 5
    aoColumnDefs: [{ 'bSortable': false, 'aTargets': [ 1,2,3,4 ] }]
    order: [[0, 'desc']]
#   aLengthMenu: [10, 25, 50, 100, 200, 300]
    sPaginationType: "bootstrap"
    processing: true
    stateSave: true
    serverSide: true
    sAjaxSource: '/api/v1/service_calls.json'

    fnServerData: (sSource, aoData, fnCallback) ->
      aoData.push
        name: "from_date"
        value: $('#from-date').val()
      aoData.push
        name: "to_date"
        value: $('#to-date').val()

      aoData.push
        name: "customer_id"
        value: $('#customer-jobs').data('customer-id')
      aoData.push
        name: "table_type"
        value: 'customer_overdue_jobs'
      aoData.push
        name: "billing_status"
        value: '4103'

      $.getJSON sSource, aoData, (json) ->
        fnCallback json

    columns: [
      {data: "ref_id", name: 'ref_id', className: 'ref_id'},
      {data: "created_at", name: 'created_at', className: 'created_at'},
      {data: "human_name", name: 'name', className: 'name'},
      {data: "human_work_status", name: 'work_status', className: 'work_status' },
      {data: "customer_balance", name: 'customer_balance', className: 'customer_balance' }
    ]

    fnRowCallback: (nRow, job, iDisplayIndex) ->
      e = new App.DataTableJobsFormater
      e.style(nRow, job)


  $('#customer-projects').dataTable
    dom: "t<'row-fluid'<'span7'i><'span5'p>>"
#    dom: "<'row-fluid'<'span6'f>r>t<'row-fluid'<'span6'i><'span6'p>>"
    pagingType: 'simple'
    iDisplayLength: 5
    aoColumnDefs: [{ 'bSortable': false, 'aTargets': [ 1,2,3,4 ] }]
    order: [[0, 'desc']]
#   aLengthMenu: [10, 25, 50, 100, 200, 300]
    sPaginationType: "bootstrap"
    processing: true
    stateSave: true
    serverSide: true
    sAjaxSource: '/projects/'

    fnServerData: (sSource, aoData, fnCallback) ->
      aoData.push
        name: "from_date"
        value: $('#projects-from-date').val()
      aoData.push
        name: "to_date"
        value: $('#projects-to-date').val()
      aoData.push
        name: "customer_id"
        value: $('#customer-projects').data('customer-id')
      aoData.push
        name: "table_type"
        value: 'customer_projects'

      $.getJSON sSource, aoData, (json) ->
        fnCallback json

    columns: [
      { data: "id" },
      { data: "created_at" },
      { data: "name" },
      { data: "status" },
      { data: 'customer' },
      { data: "provider" }
    ]

  $('#customer-statements').dataTable
    dom: "t<'row-fluid'<'span7'i><'span5'p>>"
    pagingType: 'simple'
    iDisplayLength: 5
#    aoColumnDefs: [{ 'bSortable': false, 'aTargets': [ 1,2 ] }]
    order: [[0, 'desc']]
    sPaginationType: "bootstrap"
    processing: true
    stateSave: true
    serverSide: true
    sAjaxSource: '/statements/'

    fnServerData: (sSource, aoData, fnCallback) ->
      aoData.push
        name: "from_date"
        value: $('#statement-from-date').val()
      aoData.push
        name: "to_date"
        value: $('#statement-to-date').val()
      aoData.push
        name: "statement[account_id]"
        value: $('#customer-statements').data('account-id')
      aoData.push
        name: "table_type"
        value: 'customer_statements'

      $.getJSON sSource, aoData, (json) ->
        fnCallback json

    columns: [
      { data: "id" },
      { data: "created_at" },
      { data: "balance" }
    ]

