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

  $('#job-search-results').dataTable(
    dom: "CW<'row-fluid'Tfr>tl<'row-fluid'<'span6'i><'span6'p>>"
    aoColumnDefs: [
      { 'bSortable': false, 'aTargets': [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 ] }
    ]
    order: [[0, 'desc']]
    aLengthMenu: [10, 25, 50, 100]
    sPaginationType: "bootstrap"
    oTableTools:
      aButtons: ["print"]
      sSwfPath: "/assets/dataTables/extras/swf/copy_csv_xls_pdf.swf"
    processing: true
    stateSave: true
    serverSide: true
    sAjaxSource: '/service_calls/'
    deferLoading: 0

    fnServerData: (sSource, aoData, fnCallback) ->
      aoData.push
        name: "from_date"
        value: $('#yadcf-filter--job-search-results-from-date-1').val()
      aoData.push
        name: "to_date"
        value: $('#yadcf-filter--job-search-results-to-date-1').val()
      aoData.push
        name: "customer_id"
        value: $('#customer_filter_id').val()
      aoData.push
        name: "provider_id"
        value: $('#provider').val()
      aoData.push
        name: "subcontractor_id"
        value: $('#subcontractor').val()
      aoData.push
        name: "affiliate_id"
        value: $('#affiliate').val()
      aoData.push
        name: "billing_status"
        value: $('#billing_status').val()
      aoData.push
        name: "work_status"
        value: $('#work_status').val()

      $.getJSON sSource, aoData, (json) ->
        fnCallback json

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

  ).yadcf([
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





