jQuery ->
  $('#myJobTab a:first').tab 'show'
  $('#myJobTab a:last').one 'shown.bs.tab', ->
    $('#job-search-results').dataTable().api().ajax.reload()

  $('#job-search-results').dataTable(
    dom: "CW<'row-fluid'<'span6'T><'span6'f>r>tl<'row-fluid'<'span6'i><'span6'p>>"
    columnDefs: [{ orderable: false, tragets: [ 1,2,3,4,5,6,7,8,9,10 ] }]
    order: [0, 'desc']
    aLengthMenu: [10, 25, 50, 100, 200, 300]
    sPaginationType: "bootstrap"
    oTableTools:
      aButtons: ["copy", "print",
        sExtends: "collection"
        sButtonText: "Save <span class=\"caret\" />"
        aButtons: ["csv", "xls", "pdf"]
      ],
      sSwfPath: "/assets/dataTables/extras/swf/copy_csv_xls_pdf.swf"
    processing: true
    stateSave: true
    serverSide: true
    sAjaxSource: '/service_calls/'
    deferLoading: 0

    fnServerData: (sSource, aoData, fnCallback) ->
      aoData.push
        name: "from-date"
        value: $('#yadcf-filter--job-search-results-from-date-1').val()
      aoData.push
        name: "to-date"
        value: $('#yadcf-filter--job-search-results-to-date-1').val()
      aoData.push
        name: "customer_id"
        value: $('#customer_filter_id').val()
      aoData.push
        name: "provider_id"
        value: $('#provider').val()

      $.getJSON sSource, aoData, (json) ->
        fnCallback json

  ).yadcf([
    {
      column_number: 1
      filter_container_id: 'created_range_filter'
      date_format: 'mm/dd/yyyy'
      filter_type: "range_date"
    }
    {
      column_number: 5
      select_type: 'chosen'
      filter_container_id: 'status_filter'
      filter_default_label: 'Status'
      select_type_options: {
        width: '100%'
      }

    }
    {
      column_number: 10
      select_type: 'chosen'
      filter_default_label: 'Tags'
      filter_container_id: 'tags_filter'
      data: $('#table-filters').data("tags")
      select_type_options: {
        width: '200px'
      }

    }

  ])

  # enable chosen js
  $('.chosen-select').chosen
    allow_single_deselect: true
    no_results_text: 'No results matched'
    width: '200px'

  $('#customer_search').bind 'railsAutocomplete.select', (e, data)->
    $('#job-search-results').dataTable().api().ajax.reload()

  $('#provider').on 'change', ->
    $('#customer_search').data('ref-id', $('#provider').val())
    $('#job-search-results').dataTable().api().ajax.reload()

  $('#clear-customer').live 'click', ->
    $('#customer_filter_id').val('')
    $('#customer_search').val('')
    $('#job-search-results').dataTable().api().ajax.reload()


