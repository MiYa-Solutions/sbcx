jQuery ->
  $('#customer-jobs').dataTable
    dom: "t<'row-fluid'<'span7'i><'span5'p>>"
    pagingType: 'simple'
    iDisplayLength: 5
    aoColumnDefs: [{ 'bSortable': false, 'aTargets': [ 1,2,3,4 ] }]
    order: [0, 'desc']
#   aLengthMenu: [10, 25, 50, 100, 200, 300]
    sPaginationType: "bootstrap"
    processing: true
    stateSave: true
    serverSide: true
    sAjaxSource: '/service_calls/'

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

  $('#customer-overdue-jobs').dataTable
    dom: "t<'row-fluid'<'span7'i><'span5'p>>"
    pagingType: 'simple'
    iDisplayLength: 5
    aoColumnDefs: [{ 'bSortable': false, 'aTargets': [ 1,2,3,4 ] }]
    order: [0, 'desc']
#   aLengthMenu: [10, 25, 50, 100, 200, 300]
    sPaginationType: "bootstrap"
    processing: true
    stateSave: true
    serverSide: true
    sAjaxSource: '/service_calls/'

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

