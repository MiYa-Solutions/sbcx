jQuery ->
  $('#project-jobs').dataTable
    dom: "t<'row-fluid'<'span7'i><'span5'p>>"
    pagingType: 'simple'
    iDisplayLength: 5
    aoColumnDefs: [{ 'bSortable': false, 'aTargets': [ 1,2,3,4 ] }]
    order: [0, 'desc']
    aLengthMenu: [10, 25, 50]
    sPaginationType: "bootstrap"
    processing: true
    stateSave: true
    serverSide: true
    sAjaxSource: '/service_calls/'

    fnServerData: (sSource, aoData, fnCallback) ->
      aoData.push
        name: "project_id"
        value: $('#project-jobs').data('project-id')
      aoData.push
        name: "table_type"
        value: 'project_jobs'

      $.getJSON sSource, aoData, (json) ->
        fnCallback json

