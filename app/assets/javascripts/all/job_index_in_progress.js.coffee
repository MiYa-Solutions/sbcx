$ ->
  $('#in-progress-jobs').dataTable
    dom: "<'row-fluid job-table-header'<'span4' T><'span4' f><'span4' RCW>>rtl<'row-fluid'<'span6'i><'span6'p>>"
    pagingType: "bootstrap"
    oTableTools:
      sRowSelect: 'multi'
      aButtons: [
        {
          sExtends: "print"
          oSelectorOpts: 'tr:visible'
        }
        {
          sExtends: "pdf"
          sPdfOrientation: "landscape",
          mColumns: (ctx) ->
            api = new $.fn.dataTable.Api(ctx)
            api.columns(':visible').indexes().toArray();
        }
        {
          sExtends: "xls"
          mColumns: (ctx) ->
            api = new $.fn.dataTable.Api(ctx)
            api.columns(':visible').indexes().toArray();

        }
      ]
      sSwfPath: "/assets/dataTables/extras/swf/copy_csv_xls_pdf.swf"
    iDisplayLength: 5
    columnDefs: [
      'targets': [ 1,2,3,4,5,6 ]
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
    language:
      search: ''
      searchPlaceholder: 'Search job name or ref'



    fnServerData: (sSource, aoData, fnCallback) ->
#      aoData.push
#        name: ":sSearch_5"
#        value: "New|Open|Received New|Transferred|Passed On|Accepted|Rejcted"
      aoData.push
        name: "table_type"
        value: 'in_progress_jobs'

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

  $('#transferred-in-progress-jobs').dataTable
    dom: "<'row-fluid job-table-header'<'span4' T><'span4' f><'span4' RCW>>rtl<'row-fluid'<'span6'i><'span6'p>>"
    pagingType: "bootstrap"
    oTableTools:
      sRowSelect: 'multi'
      aButtons: [
        {
          sExtends: "print"
          oSelectorOpts: 'tr:visible'
        }
        {
          sExtends: "pdf"
          sPdfOrientation: "landscape",
          mColumns: (ctx) ->
            api = new $.fn.dataTable.Api(ctx)
            api.columns(':visible').indexes().toArray();
        }
        {
          sExtends: "xls"
          mColumns: (ctx) ->
            api = new $.fn.dataTable.Api(ctx)
            api.columns(':visible').indexes().toArray();

        }
      ]
      sSwfPath: "/assets/dataTables/extras/swf/copy_csv_xls_pdf.swf"
    iDisplayLength: 5
    columnDefs: [
      'targets': [ 1,2,3,4,5,6 ]
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
    language:
      search: ''
      searchPlaceholder: 'Search job name or ref'


    fnServerData: (sSource, aoData, fnCallback) ->
#      aoData.push
#        name: ":sSearch_5"
#        value: "New|Open|Received New|Transferred|Passed On|Accepted|Rejcted"
      aoData.push
        name: "table_type"
        value: 'transferred_in_progress_jobs'

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

  $("a[href='#activeJobs']").one 'shown.bs.tab', ->
    $('#in-progress-jobs').dataTable().api().ajax.reload()
    $('#transferred-in-progress-jobs').dataTable().api().ajax.reload()

  if $('#activeJobs').is(':visible')
    $('#in-progress-jobs').dataTable().api().ajax.reload()
    $('#transferred-in-progress-jobs').dataTable().api().ajax.reload()



