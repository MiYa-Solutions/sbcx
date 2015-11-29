filter_params = ->

  res = ''
  res = res + 'from_date=' + $('#yadcf-filter--job-search-results-from-date-1').val() + '&'
  res = res + 'to_date=' + $('#yadcf-filter--job-search-results-to-date-1').val() + '&'
  res = res + 'customer_id=' + $('#customer_filter_id').val() + '&'
  res = res + 'provider_id=' + $('#provider').val() + '&'
  res = res + 'subcontractor_id=' + $('#subcontractor').val() + '&'
  res = res + 'affiliate_id=' + $('#affiliate').val() + '&'
  res = res + 'billing_status=' + $('#billing_status').val() + '&'
  res = res + 'work_status=' + $('#work_status').val() + '&'
  res

Jobs = {
full_url: (postfix = 'csv')->
  "service_calls.#{postfix}?" + filter_params() + $.param( $('#job-search-results').dataTable().api().ajax.params())
}

$.getRequetParam = (name)->
  name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]")
  regex = new RegExp("[\\?&]" + name + "=([^&#]*)")
  results = regex.exec(location.search)
  (if not results? then "" else decodeURIComponent(results[1].replace(/\+/g, " ")))
jQuery ->
#  $('#myJobTab a:first').tab 'show'
  $("a[href='#allJobs']").one 'shown.bs.tab', ->
    $('#job-search-results').dataTable().api().ajax.reload()

  dataTable = $('#job-search-results').DataTable(
    dom: "RCW<'row-fluid'Tfr>tl<'row-fluid'<'span6'i><'span6'p>>"
    order: [[0, 'desc']]
    aLengthMenu: [10, 25, 50, 100]
    pagaingType: "bootstrap"

    oTableTools:
      sRowSelect: 'multi'
      aButtons: [
        {
          sExtends: "print"
          oSelectorOpts: 'tr:visible'
          bSelectedOnly: true
        }
      ]
      sSwfPath: "/assets/dataTables/extras/swf/copy_csv_xls_pdf.swf"
    processing: true
    stateSave: true
    serverSide: true
    autoWidth: false
    responsive: true
    deferLoading: 0
    ajax:
      url: '/api/v1/datatables/service_calls.json'
      data: (d) ->
        d.table_type = 'all_jobs'
        d.filters = {}
        d.filters.status = $('#yadcf-filter--job-search-results-5').val()
        d.filters.from_date = $('#yadcf-filter--job-search-results-from-date-1').val()
        d.filters.to_date = $('#yadcf-filter--job-search-results-to-date-1').val()
        d.filters.customer_id = $('#customer_filter_id').val()
        d.filters.provider_id = $('#provider').val()
        d.filters.subcontractor_id = $('#subcontractor').val()
        d.filters.affiliate_id = $('#affiliate').val()
        d.filters.billing_status = $('#billing_status').val()



    fnStateSaveParams: (oSettings, oData) ->
      oData.customer_id = $('#customer_filter_id').val()
      oData.customer_name = $('#customer_search').val()
      oData.provider_id = $('#provider').val()
      oData.subcontractor_id = $('#subcontractor').val()
      oData.affiliate_id = $('#affiliate').val()
      oData.billing_status = $('#billing_status').val()
      oData.work_status = $('#work_status').val()

    fnStateLoadParams: (oSettings, oData) ->
      $('#customer_search').val(oData.customer_name)
      $('#customer_filter_id').val(oData.customer_id)
      $('#provider').val(oData.provider_id)
      $('#subcontractor').val(oData.subcontractor_id)
      $('#affiliate').val(oData.affiliate_id)
      $('#billing_status').val(oData.billing_status)
      $('#work_status').val(oData.work_status)

    columns: [
      {data: "ref_id", className: 'ref_id', name: 'ref_id', orderable: true, sWidth: '1%'},
      {data: "started_on", className: 'started_on', name: 'started_on', orderable: false, width: '20%', searchable: false},
      {data: "human_customer", className: 'customer', name: 'customer_id', orderable: false, width: '20%', searchable: false},
      {data: "human_name", className: 'name', name: 'name', orderable: false, sWidth: '25%'},
      {data: "human_provider", className: 'provider', name: 'human_provider', orderable: false, width: '1%', searchable: false},
      {data: "human_subcontractor", className: 'subcontractor', name: 'human_subcontractor', orderable: false, width: '1%', searchable: false},
      {data: "human_status", className: 'status', name: 'human_status', orderable: false, width: '1%', searchable: false},
      {data: "my_profit", className: 'total_price', name: 'my_profit', orderable: false, width: '3%', searchable: false},
      {data: "total_price", className: 'total_price', name: 'total_price', orderable: false, width: '3%', searchable: false},
      {data: "total_cost", className: 'total_cost', name: 'total_cost', orderable: false, width: '3%', searchable: false},
      {data: "tags", className: 'tags', name: 'tags', orderable: false, width: '30%', searchable: false},
      {data: "external_ref", className: 'external_ref', name: 'external_ref', orderable: false, width: '10%'}
    ]

    fnRowCallback: (nRow, job, iDisplayIndex) ->
      e = new App.DataTableJobsFormater
      e.style(nRow, job)


  )

  yadcf.init(dataTable, [
    {
      column_number: 1
      filter_container_id: 'created_range_filter'
      date_format: 'mm/dd/yyyy'
      filter_type: "range_date"
    }
    {
      column_number: 5
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
    {
      column_number: 10
      select_type: 'chosen'
      filter_type: 'multi_select'
      filter_default_label: 'Tags'
      filter_container_id: 'tags_filter'
      data: $('#table-filters').data("tags")
      select_type_options:
        {
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

  $('#affiliate').on 'change', ->
    $('#customer_search').data('ref-id', $('#affiliate').val())
    $('#job-search-results').dataTable().api().ajax.reload()

  $('#subcontractor').on 'change', ->
    $('#job-search-results').dataTable().api().ajax.reload()

  $('#work_status').on 'change', ->
    $('#job-search-results').dataTable().api().ajax.reload()

  $('#billing_status').on 'change', ->
    $('#job-search-results').dataTable().api().ajax.reload()

  $('#clear-customer').live 'click', ->
    $('#customer_filter_id').val('')
    $('#customer_search').val('')
    $('#job-search-results').dataTable().api().ajax.reload()

  $('#clear-provider').live 'click', ->
    $('#provider').val($('#provider option:first').val())
    $("#provider").trigger("chosen:updated")
    $('#job-search-results').dataTable().api().ajax.reload()

  $('#clear-subcontractor').live 'click', ->
    $('#subcontractor').val($('#subcontractor option:first').val())
    $("#subcontractor").trigger("chosen:updated")
    $('#job-search-results').dataTable().api().ajax.reload()

  $('#clear-affiliate').live 'click', ->
    $('#affiliate').val($('#affiliate option:first').val())
    $("#affiliate").trigger("chosen:updated")
    $('#job-search-results').dataTable().api().ajax.reload()

  $('#clear-work-status').live 'click', ->
    $('#work_status').val($('#work_status option:first').val())
    $("#work_status").trigger("chosen:updated")
    $('#job-search-results').dataTable().api().ajax.reload()

  $('#clear-billing-status').live 'click', ->
    $('#billing_status').val($('#billing_status option:first').val())
    $("#billing_status").trigger("chosen:updated")
    $('#job-search-results').dataTable().api().ajax.reload()


  $('.download_csv').on 'click', (e)->
    e.preventDefault()
    window.location = Jobs.full_url()

  if $('#allJobs').is(':visible')
    $('#job-search-results').dataTable().api().ajax.reload()





