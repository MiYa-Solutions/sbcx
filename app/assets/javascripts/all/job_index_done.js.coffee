class App.DoneJobsFormatter
  constructor: ->


  style: (row, job) ->
    @color_cells(row, job)
    @format_money(row, job)

  color_cells: (row, job) ->
    img = HandlebarsTemplates['jobs/overdue_job']()
    if job.billing_status == 'overdue'
      $('.customer', row).append(img)
      $(img).tooltip()

  format_money: (row, job) ->
    @format_customer_balance(row, job)
    @format_subcontractor_balance(row, job)
    @format_contractor_balance(row, job)

  format_customer_balance: (row, job) ->
    amount = parseInt(job.customer_balance) / 100
    ccy = job.customer_balance_ccy_sym

    formated_amount = accounting.formatMoney(amount)
    $('.customer_balance', row).text(formated_amount)
    if amount >= 0.0
      $('.customer_balance', row).addClass('green_amount')
    else
      $('.customer_balance', row).addClass('red_amount')

  format_subcontractor_balance: (row, job) ->
    amount = parseInt(job.subcontractor_balance) / 100
    ccy = job.subcontractor_balance_ccy_sym

    formated_amount = accounting.formatMoney(amount)
    $('.subcontractor_balance', row).text(formated_amount)
    if amount >= 0.0
      $('.subcontractor_balance', row).addClass('green_amount')
    else
      $('.subcontractor_balance', row).addClass('red_amount')

  format_contractor_balance: (row, job) ->
    amount = parseInt(job.contractor_balance) / 100
    ccy = job.contractor_balance_ccy_sym

    formated_amount = accounting.formatMoney(amount)
    $('.contractor_balance', row).text(formated_amount)
    if amount >= 0.0
      $('.contractor_balance', row).addClass('green_amount')
    else
      $('.contractor_balance', row).addClass('red_amount')

$ ->
  $('#done-jobs').dataTable
    dom: "t<'row-fluid'<'span7'i><'span5'p>>"
    pagingType: 'simple'
    iDisplayLength: 5
    order: [[0, 'desc']]
    aLengthMenu: [10, 25, 50]
    sPaginationType: "bootstrap"
    processing: true
    stateSave: true
    sAjaxSource: 'api/v1/service_calls.json'
    serverSide: true
    responsive: true
    deferLoading: 0


    fnServerData: (sSource, aoData, fnCallback) ->
      aoData.push
        name: "table_type"
        value: 'done_jobs'

      $.getJSON sSource, aoData, (json) ->
        fnCallback json

    columns: [
      {data: "ref_id", className: 'ref_id', name: 'ref_id', orderable: true},
      {data: "human_name", className: 'name', name: 'name', orderable: false},
      {data: "customer", className: 'customer', name: 'customer', orderable: false},
      {data: "customer_balance", className: 'customer_balance', name: 'customer_balance', orderable: false},
      {data: "completed_on", className: 'completed_on', name: 'completed_on', orderable: false},
      {data: "contractor", className: 'contractor', name: 'contractor', orderable: false},
      {data: "contractor_balance", className: 'contractor_balance', name: 'contractor_balance', orderable: false}
    ]

    fnRowCallback: (nRow, job, iDisplayIndex) ->
      e = new App.DoneJobsFormatter
      e.style(nRow, job)

  $('#done-transferred-jobs').dataTable
    dom: "t<'row-fluid'<'span7'i><'span5'p>>"
    pagingType: 'simple'
    iDisplayLength: 5
    order: [[0, 'desc']]
    sPaginationType: "bootstrap"
    processing: true
    stateSave: true
    sAjaxSource: 'api/v1/service_calls.json'
    serverSide: true
    responsive: true
    deferLoading: 0


    fnServerData: (sSource, aoData, fnCallback) ->
      aoData.push
        name: "table_type"
        value: 'done_transferred_jobs'

      $.getJSON sSource, aoData, (json) ->
        fnCallback json

    columns: [
      {data: "ref_id", className: 'ref_id', name: 'ref_id', orderable: true},
      {data: "human_name", className: 'name', name: 'name', orderable: false},
      {data: "customer", className: 'customer', name: 'customer', orderable: false},
      {data: "customer_balance", className: 'customer_balance', name: 'customer_balance', orderable: false},
      {data: "completed_on", className: 'completed_on', name: 'completed_on', orderable: false},
      {data: "contractor", className: 'contractor', name: 'contractor', orderable: false}
      {data: "contractor_balance", className: 'contractor_balance', name: 'contractor_balance', orderable: false},
      {data: "subcontractor", className: 'subcontractor', name: 'subcontractor', orderable: false},
      {data: "subcontractor_balance", className: 'subcontractor_balance', name: 'subcontractor_balance', orderable: false}
#      {name: 'indicator', data: null, className: 'indicator',  defaultContent: '', orderable: false, sortable: false}
    ]

    fnRowCallback: (nRow, job, iDisplayIndex) ->
      e = new App.DoneJobsFormatter
      e.style(nRow, job)


  $("a[href='#doneJobs']").one 'shown.bs.tab', ->
    $('#done-jobs').dataTable().api().ajax.reload()
    $('#done-transferred-jobs').dataTable().api().ajax.reload()

  if $('#doneJobs').is(':visible')
    $('#done-jobs').dataTable().api().ajax.reload()
    $('#done-transferred-jobs').dataTable().api().ajax.reload()
