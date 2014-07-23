jQuery ->
  $('#customer-jobs').dataTable
    dom: "<'row-fluid'<'span6'><'span6'>r>t<'row-fluid'<'span6'i><'span6'p>>"
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

