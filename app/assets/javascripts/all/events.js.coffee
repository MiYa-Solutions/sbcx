$ ->
  $('table.events').dataTable
    dom: "t<'row-fluid'<'span7'i><'span5'p>>"
    pagingType: 'simple'
    iDisplayLength: 5
    aoColumnDefs: [{ 'bSortable': false, 'aTargets': [ 1,2,3,4 ] }]
    deferLoading: 0
    order: [0, 'desc']
  #   aLengthMenu: [10, 25, 50, 100, 200, 300]
    sPaginationType: "bootstrap"
    processing: true
    stateSave: true
    serverSide: true
    sAjaxSource: '/events/'

    fnServerData: (sSource, aoData, fnCallback) ->
      aoData.push
        name: "eventable_id"
        value: window.location.pathname.substring(window.location.pathname.lastIndexOf('/') + 1)
      aoData.push
        name: "eventable_type"
        value: 'Ticket'
      #      aoData.push
      #        name: "from_date"
      #        value: $('#from-date').val()
      #      aoData.push
      #        name: "to_date"
      #        value: $('#to-date').val()

      $.getJSON sSource, aoData, (json) ->
        fnCallback json

  $('#myJobShowTab a:last').one 'shown.bs.tab', ->
    $('table.events').dataTable().api().ajax.reload()

