TableTools.BUTTONS.download =
  sAction: "text"
  sTag: "default"
  sFieldBoundary: ""
  sFieldSeperator: "\t"
  sNewLine: "<br>"
  sToolTip: ""
  sButtonClass: "DTTT_button_text"
  sButtonClassHover: "DTTT_button_text_hover"
  sButtonText: "Download"
  mColumns: "all"
  bHeader: true
  bFooter: true
  sDiv: ""
  fnMouseover: null
  fnMouseout: null
  fnClick: (nButton, oConfig) ->
    oParams = @s.dt.oApi._fnAjaxParameters(@s.dt)
    iframe = document.createElement("iframe")
    iframe.style.height = "0px"
    iframe.style.width = "0px"
    iframe.src = oConfig.sUrl + "?" + $.param(oParams)
    document.body.appendChild iframe
    return

  fnSelect: null
  fnComplete: null
  fnInit: null


$.getRequetParam = (name)->
  name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]")
  regex = new RegExp("[\\?&]" + name + "=([^&#]*)")
  results = regex.exec(location.search)
  (if not results? then "" else decodeURIComponent(results[1].replace(/\+/g, " ")))
jQuery ->
  $('#myJobTab a:first').tab 'show'
  $('#myJobTab a:last').one 'shown.bs.tab', ->
    $('#job-search-results').dataTable().api().ajax.reload()

  $('#job-search-results').dataTable(
    dom: "CW<'row-fluid'<'span6'T><'span6'f>r>tl<'row-fluid'<'span6'i><'span6'p>>"
    aoColumnDefs: [
      { 'bSortable': false, 'aTargets': [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ] }
    ]
    order: [0, 'desc']
    aLengthMenu: [10, 25, 50, 100, 200, 300]
    sPaginationType: "bootstrap"
    oTableTools:
      aButtons:[ "Save"
        sExtends: "download",
        sUrl: 'service_calls/']

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

      $.getJSON sSource, aoData, (json) ->
        fnCallback json

    fnStateSaveParams: (oSettings, oData) ->
      oData.customer_id = $('#customer_filter_id').val()
      oData.customer_name = $('#customer_search').val()
      oData.provider_id = $('#provider').val()
      oData.subcontractor_id = $('#subcontractor').val()
      oData.affiliate_id = $('#affiliate').val()

    fnStateLoadParams: (oSettings, oData) ->
      $('#customer_search').val(oData.customer_name)
      $('#customer_filter_id').val(oData.customer_id)
      $('#provider').val(oData.provider_id)
      $('#subcontractor').val(oData.subcontractor_id)
      $('#affiliate').val(oData.affiliate_id)

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



