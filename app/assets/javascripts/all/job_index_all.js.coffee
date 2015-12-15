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
    "service_calls.#{postfix}?" + filter_params() + $.param($('#job-search-results').dataTable().api().ajax.params())
}



dateRange = {
  element: -> $('#created-at-range')
  endDate: -> if this.element().val() != '' then this.element().data('daterangepicker').endDate.format('MMMM Do YYYY, h:mm:ss a') else ''
  startDate: -> if this.element().val() != '' then this.element().data('daterangepicker').startDate.format('MMMM Do YYYY, h:mm:ss a') else ''
}



$.getRequetParam = (name)->
  name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]")
  regex = new RegExp("[\\?&]" + name + "=([^&#]*)")
  results = regex.exec(location.search)
  (if not results? then "" else decodeURIComponent(results[1].replace(/\+/g, " ")))
jQuery ->
  statusFilter = {
    ticketStatuses: [
      {id: 0, text: 'New'}
      {id: 1, text: 'Open'}
      {id: 2, text: 'Transferred'}
      {id: 3, text: 'Closed'}
      {id: 4, text: 'Canceled'}
      {id: 1201, text: 'Accepted'}
      {id: 1202, text: 'Rejected'}
    ]

    element: -> $('#status_filter')
    val: ->
      return this.element().select2('val')

    setVal: (value) ->
      this.element().select2('val', value)

    init: ->
      this.element().select2({
        width: 'copy'
        data: this.ticketStatuses
        multiple: true
      })

      this.element().on 'select2-selecting', ->
        $('#job-search-results').DataTable().ajax.reload()

  }

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
        }
        {
          sExtends: "pdf"
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
    processing: true
    stateSave: true
    serverSide: true
    autoWidth: false
#    responsive: true
    deferLoading: 0
    ajax:
      url: '/api/v1/datatables/service_calls.json'
      data: (d) ->
        d.table_type = 'all_jobs'
        d.filters = {}
        d.filters.status = yadcf.exGetColumnFilterVal(dataTable, 6)
        d.filters.technician_id = yadcf.exGetColumnFilterVal(dataTable, 12)
        d.filters.from_date = dateRange.startDate()
        d.filters.to_date = dateRange.endDate()
        d.filters.customer_id = $('#customer_filter_id').val()
        d.filters.provider_id = $('#provider').val()
        d.filters.subcontractor_id = $('#subcontractor').val()
        d.filters.affiliate_id = $('#affiliate').val()
        d.filters.billing_status = $('#billing_status').val()




    fnStateSaveParams: (oSettings, oData) ->
      oData.customer_id = $('#customer_filter_id').val()
      #      oData.status = statusFilter.val()
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
#      statusFilter.setVal(oData.status)

    columns: [
      {data: "ref_id", className: 'ref_id', name: 'ref_id', orderable: true, sWidth: '1%', title: 'Ref'},
      {
        data: "started_on",
        title: "Started On",
        className: 'started_on',
        name: 'started_on',
        orderable: false,
        searchable: false
      },
      {
        data: "human_customer",
        title: "Customer",
        className: 'customer',
        name: 'customer_id',
        orderable: false,
        searchable: false
      },
      {data: "human_name", className: 'name', name: 'name', orderable: false, sWidth: '25%', title: 'Name'},
      {
        data: "human_provider",
        title: "Contractor",
        className: 'provider',
        name: 'human_provider',
        orderable: false,
        searchable: false
      },
      {
        data: "human_subcontractor",
        title: "Subcontractor",
        className: 'subcontractor',
        name: 'human_subcontractor',
        orderable: false,
        searchable: false
      },
      {
        data: "human_status",
        title: "Status",
        className: 'status',
        name: 'human_status',
        orderable: false,
        searchable: true,
        searchable: false
      },
      {
        data: "my_profit",
        title: "Profit",
        className: 'total_price',
        name: 'my_profit',
        orderable: false,
        searchable: false
      },
      {
        data: "total_price",
        title: "Total Price",
        className: 'total_price',
        name: 'total_price',
        orderable: false,
        searchable: false
      },
      {
        data: "total_cost",
        title: "Total Cost",
        className: 'total_cost',
        name: 'total_cost',
        orderable: false,
        searchable: false
      },
      {data: "tags", title: 'Tags', className: 'tags', name: 'tags', orderable: false, width: '30%', searchable: false},
      {
        data: "external_ref",
        title: 'Ext. Ref',
        className: 'external_ref',
        name: 'external_ref',
        orderable: false,
      },
      {
        data: "technician_name",
        title: 'Technician',
        className: 'technician_name',
        name: 'technician_name',
        orderable: false,
        searchable: true
      },
      {
        data: "full_address",
        title: 'Address',
        className: 'full_address',
        name: 'full_address',
        orderable: false,
        searchable: true
      }
    ]

    fnRowCallback: (nRow, job, iDisplayIndex) ->
      e = new App.DataTableJobsFormater
      e.style(nRow, job)
  )

  $('#created-at-range').daterangepicker(
    timePicker: true,
    timePickerIncrement: 30,
    autoUpdateInput: false,
    locale: {
      cancelLabel: 'Clear'
      format: 'MM/DD/YYYY h:mm A'
    },
    ranges: {
      'Today': [moment(), moment()],
      'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
      'Last 7 Days': [moment().subtract(6, 'days'), moment()],
      'Last 30 Days': [moment().subtract(29, 'days'), moment()],
      'This Month': [moment().startOf('month'), moment().endOf('month')],
      'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')]
    }

#    (start, end, label) ->
#      $('#job-search-results').DataTable().ajax.reload()
  )

  dateRange.element().on 'apply.daterangepicker', (ev, picker) ->
    $(this).val picker.startDate.format('MM/DD/YYYY') + ' - ' + picker.endDate.format('MM/DD/YYYY')
    dataTable.ajax.reload()
    return

  dateRange.element().on 'cancel.daterangepicker', (ev, picker) ->
    $(this).val ''
    dataTable.ajax.reload()
    return

  #  statusFilter.init()


  yadcf.init(dataTable, [
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

    {
      column_number: 6
      select_type: 'chosen'
      filter_type: 'multi_select'
      filter_default_label: 'Status'
      filter_container_id: 'status_filter'
      data: [{value: 1, label: 'yalla'}, {value: 2, label: 'kvar'}]
      select_type_options:
        {
          width: '200px'
        }

    }
    {
      column_number: 12
      filter_type: 'select'
      select_type: 'chosen'
      filter_default_label: 'Tech'
      data: $('#tech_filter').data('tech-list')
      filter_container_id: 'tech_filter'

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
    $('#customer_filter_id').val('')
    $('#customer_search').val('')
    prov_id = $('#provider').val()
    $('#customer_search').val('')
    $('#customer_search').attr("data-ref-id", prov_id)
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
    dataTable.ajax.reload()
