jQuery ->
  $('table.projects').dataTable(
    sDom: "<'row-fluid'<'span6'T><'span6'f>r>tl<'row-fluid'<'span6'i><'span6'p>>"
    pagingType: 'simple'
    iDisplayLength: 5
    aoColumnDefs: [{ 'bSortable': false, 'aTargets': [ 1,2,3,4 ] }]
    order: [0, 'desc']
  #   aLengthMenu: [10, 25, 50, 100, 200, 300]
    sPaginationType: "bootstrap"
    processing: true
    stateSave: true
    serverSide: true
    sAjaxSource: '/projects/'
    oTableTools:
      aButtons: ["copy", "print",
        sExtends: "collection"
        sButtonText: "Save <span class=\"caret\" />"
        aButtons: ["csv", "xls", "pdf"]
      ],
      sSwfPath: "assets/dataTables/extras/swf/copy_csv_xls_pdf.swf"

    fnServerData: (sSource, aoData, fnCallback) ->
      aoData.push
        name: "provider_id"
        value: $('#project_provider_filter').val()

      aoData.push
        name: "customer_id"
        value: $('#customer_filter_id').val()
      aoData.push
          name: "from_date"
          value: $('#yadcf-filter-table-projects-from-date-2').val()
      aoData.push
        name: "to_date"
        value: $('#yadcf-filter-table-projects-to-date-2').val()

      $.getJSON sSource, aoData, (json) ->
        fnCallback json

    fnStateSaveParams: (oSettings, oData) ->
      oData.provider_id = $('#project_provider_filter').val()
      oData.customer_id = $('#customer_filter_id').val()
      oData.customer_name = $('#customer_search').val()

    fnStateLoadParams: (oSettings, oData) ->
      $('#project_provider_filter').val(oData.provider_id)
      $('#customer_filter_id').val(oData.customer_id)
      $('#customer_search').val(oData.customer_name)

    columns: [
        { data: "id" },
        { data: "created_at" },
        { data: "name" },
        { data: "status" },
        { data: 'customer' },
        { data: "provider" }
      ]
  ).yadcf([
    {
      column_number: 2
      filter_container_id: 'created_range_filter'
      date_format: 'mm/dd/yyyy'
      filter_type: "range_date"
    }
    {
      column_number: 4
      filter_type: 'multi_select'
      select_type: 'chosen'
      data: $('#table-filters').data("statuses")
      filter_container_id: 'status_filter'
      filter_default_label: 'Status'
      select_type_options:
        {
          width: '200px'
        }
    }
  ])

  $('#clear-customer').live 'click', ->
    $('#customer_filter_id').val('')
    $('#customer_search').val('')
    $('table.projects').dataTable().api().ajax.reload()

  $('#customer_search').bind 'railsAutocomplete.select', (e, data)->
    $('table.projects').dataTable().api().ajax.reload()

  $('#project_provider_filter').on 'change', ->
    $('#customer_search').attr('data-ref-id', $('#project_provider_filter').attr('value'))
    $('table.projects').dataTable().api().ajax.reload()

  $('#clear-provider').live 'click', ->
    $('#project_provider_filter').val($('#project_provider_filter option:first').val())
    $("#project_provider_filter").trigger("chosen:updated")
    $('#customer_search').attr('data-ref-id', '')
    $('#customer_filter_id').val('')
    $('#customer_search').val('')
    $('table.projects').dataTable().api().ajax.reload()
