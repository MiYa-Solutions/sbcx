autoload_state = true
jQuery.fn.dataTable.Api.register 'state.load()', ->
  @iterator 'table', (s) ->
# Force the state load. Note something isn't quite right with column visibility...
    s.oApi._fnLoadState s, s.oInit
    # ...so we need to check for which ones should be hidden in the loaded state...
    hidden_cols = []
    jQuery.each s.oLoadedState.columns, (i, column) ->
      if !column.visible
        hidden_cols.push i
    # set them all to be visible...
    s.oInstance.DataTable().columns().visible true
    # ...then hide the ones that should be hidden:
    s.oInstance.DataTable().columns(hidden_cols).visible false
#    header = ""
#    table = s.oInstance.DataTable()
#    jQuery.each table.columns(), (i, column) ->
#      header = header + column.header() unless column.visible == false
#
#    $(s.oInstance.DataTable().header()).html(header)




#filter_params = ->
#  res = ''
#  res = res + 'from_date=' + $('#yadcf-filter--job-search-results-from-date-1').val() + '&'
#  res = res + 'to_date=' + $('#yadcf-filter--job-search-results-to-date-1').val() + '&'
#  res = res + 'customer_id=' + $('#customer_filter_id').val() + '&'
#  res = res + 'provider_id=' + $('#provider').val() + '&'
#  res = res + 'subcontractor_id=' + $('#subcontractor').val() + '&'
#  res = res + 'affiliate_id=' + $('#affiliate').val() + '&'
#  res = res + 'billing_status=' + $('#billing_status').val() + '&'
#  res = res + 'work_status=' + $('#work_status').val() + '&'
#  res

Jobs = {
  full_url: (postfix = 'csv')->
    "service_calls.#{postfix}?" + filter_params() + $.param($('#job-search-results').dataTable().api().ajax.params())
}


$.getRequetParam = (name)->
  name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]")
  regex = new RegExp("[\\?&]" + name + "=([^&#]*)")
  results = regex.exec(location.search)
  (if not results? then "" else decodeURIComponent(results[1].replace(/\+/g, " ")))

jQuery ->

#  $('#myJobTab a:first').tab 'show'
  if $('#job-search-results').length > 0
    dateRange = new App.DateRangeFilter($('#created-at-range'), $('#job-search-results'), $('#clear-created-range'))
    startDateRange = new App.DateRangeFilter($('#started-on-range'), $('#job-search-results'), $('#clear-started-range'))
    scheduledDateRange = new App.DateRangeFilter($('#scheduled-for-range'), $('#job-search-results'), $('#clear-scheduled-range'))
    completedDateRange = new App.DateRangeFilter($('#completed-at-range'), $('#job-search-results'), $('#clear-completed-range'))
    employeeFilter = new App.EmployeeFilter($('#job-search-results'), $('#employee_id'), $('#clear-employee'))
    techFilter = new App.TechnicianFilter($('#job-search-results'), $('#technician_id'), $('#clear-tech'))
    tagsFilter = new App.Filter($('#job-search-results'), $('#tags'), $('#clear-tags'))
    statusFilter = new App.JobStatusFilter($('#job-search-results'), $('#status'), $('#clear-status'))
    workStatusFilter = new App.WorkStatusFilter($('#job-search-results'), $('#work_status'), $('#clear-work-status'))
    billingStatusFilter = new App.BillingStatusFilter($('#job-search-results'), $('#billing_status'), $('#clear-billing-status'))
    contractorFilter = new App.ContractorFilter($('#job-search-results'), $('#provider'), $('#clear-provider'))
    subconFilter = new App.SubcontractorFilter($('#job-search-results'), $('#subcontractor'), $('#clear-subcontractor'))
    affiliateFilter = new App.AffiliateFilter($('#job-search-results'), $('#affiliate'), $('#clear-affiliate'))


    dataTable = $('#job-search-results').DataTable(
      dom: "<'row-fluid'<'span4' T><'span4' f><'span4' RCW>>rtl<'row-fluid'<'span6'i><'span6'p>>"
#      dom: "RCW<'row-fluid'Tfr>tl<'row-fluid'<'span6'i><'span6'p>>"
      order: [[0, 'desc']]
      aLengthMenu: [10, 25, 50, 100]
      pagaingType: "bootstrap"
#
#      'stateLoadCallback': (settings) ->
#        console.log 'stateLoadCallback'
#        return JSON.parse(localStorage.getItem('datatable-data'+localStorage.getItem('index')))
#
#      'stateSaveCallback': (settings, data) ->
#        console.log 'stateSaveCallback'
#        t = settings.oInstance.DataTable()
#        drawVisibleColumnHeader(t)

      language:
        search: ''
        searchPlaceholder: 'Search job name or ref'

      oTableTools:
        sRowSelect: 'multi'
        aButtons: [
          {
            sExtends: "print"
            oSelectorOpts: 'tr:visible'
          }
          {
            sExtends: "pdf"
            sPdfOrientation: "landscape",
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
          d.filters.status = statusFilter.getVal()
          d.filters.technician_id = techFilter.getVal()
          d.filters.employee_id = employeeFilter.getVal()
          d.filters.from_date = dateRange.startDate()
          d.filters.to_date = dateRange.endDate()
          d.filters.started_from_date = startDateRange.startDate()
          d.filters.started_to_date = startDateRange.endDate()
          d.filters.completed_from_date = completedDateRange.startDate()
          d.filters.completed_to_date = completedDateRange.endDate()
          d.filters.scheduled_from_date = scheduledDateRange.startDate()
          d.filters.scheduled_to_date = scheduledDateRange.endDate()
          d.filters.customer_id = $('#customer_filter_id').val()
          d.filters.provider_id = contractorFilter.getVal()
          d.filters.subcontractor_id = subconFilter.getVal()
          d.filters.affiliate_id = affiliateFilter.getVal()
          d.filters.billing_status = billingStatusFilter.getVal()
          d.filters.work_status = workStatusFilter.getVal()
          d.filters.tags = tagsFilter.getVal()
          return

      fnStateSaveParams: (oSettings, oData) ->
        oData.filters = {}
        oData.filters.customer_id = $('#customer_filter_id').val()
        oData.filters.from_date = dateRange.startDate()
        oData.filters.to_date = dateRange.endDate()
        oData.filters.started_from_date = startDateRange.startDate()
        oData.filters.started_to_date = startDateRange.endDate()
        oData.filters.scheduled_from_date = scheduledDateRange.startDate()
        oData.filters.scheduled_to_date = scheduledDateRange.endDate()
        oData.filters.completed_from_date = completedDateRange.startDate()
        oData.filters.completed_to_date = completedDateRange.endDate()
        oData.filters.customer_name = $('#customer_search').val()
        oData.filters.provider_id = contractorFilter.getVal()
        oData.filters.subcontractor_id = subconFilter.getVal()
        oData.filters.affiliate_id = affiliateFilter.getVal()
        oData.filters.billing_status = billingStatusFilter.getVal()
        oData.filters.work_status = workStatusFilter.getVal()
        oData.filters.billing_status = billingStatusFilter.getVal()
        oData.filters.technician_id = techFilter.getVal()
        oData.filters.employee_id = employeeFilter.getVal()
        oData.filters.status = statusFilter.getVal()
        oData.filters.tags = tagsFilter.getVal()


      fnStateLoadParams: (oSettings, oData) ->
        $('#customer_search').val(oData.filters.customer_name)
        $('#customer_filter_id').val(oData.filters.customer_id)
        contractorFilter.setValNoReload(oData.filters.provider_id)
        subconFilter.setValNoReload(oData.filters.subcontractor_id)
        affiliateFilter.setValNoReload(oData.filters.affiliate_id)
        billingStatusFilter.setValNoReload(oData.filters.billing_status)
        workStatusFilter.setValNoReload(oData.filters.work_status)
        employeeFilter.setValNoReload(oData.filters.employee_id)
        techFilter.setValNoReload(oData.filters.technician_id)
        statusFilter.setValNoReload(oData.filters.status)
        billingStatusFilter.setValNoReload(oData.filters.billing_status)
        tagsFilter.setValNoReload(oData.filters.tags)
        if oData.filters != undefined
          dateRange.setRange(oData.filters.from_date, oData.filters.to_date)
          startDateRange.setRange(oData.filters.started_from_date, oData.filters.started_to_date)
          scheduledDateRange.setRange(oData.filters.scheduled_from_date, oData.filters.scheduled_to_date)
          completedDateRange.setRange(oData.filters.completed_from_date, oData.filters.completed_to_date)

      columns: [
# 0
        {data: "ref_id", className: 'ref_id', name: 'ref_id', orderable: true, title: 'Ref'},
# 1
        {
          data: "started_on",
          title: "Started On",
          className: 'started_on',
          name: 'started_on',
          orderable: false,
          searchable: false
        },
# 2
        {
          data: "human_customer",
          title: "Customer",
          className: 'customer',
          name: 'customer_id',
          orderable: false,
          searchable: false
        },
# 3
        {data: "human_name", className: 'name', name: 'name', orderable: false, title: 'Name'},
# 4
        {
          data: "human_provider",
          title: "Contractor",
          className: 'provider',
          name: 'human_provider',
          orderable: false,
          searchable: false
        },
# 5
        {
          data: "human_subcontractor",
          title: "Subcontractor",
          className: 'subcontractor',
          name: 'human_subcontractor',
          orderable: false,
          searchable: false
        },
# 6
        {
          data: "human_status",
          title: "Status",
          className: 'status',
          name: 'human_status',
          orderable: false,
          searchable: true,
          searchable: false
        },
# 7
        {
          data: "my_profit",
          title: "Profit",
          className: 'total_price',
          name: 'my_profit',
          orderable: false,
          searchable: false
        },
# 8
        {
          data: "total_price",
          title: "Total Price",
          className: 'total_price',
          name: 'total_price',
          orderable: false,
          searchable: false
        },
# 9
        {
          data: "total_cost",
          title: "Total Cost",
          className: 'total_cost',
          name: 'total_cost',
          orderable: false,
          searchable: false
        },
# 10
        {data: "tags", title: 'Tags', className: 'tags', name: 'tags', orderable: false, searchable: false},
# 11
        {
          data: "external_ref",
          title: 'Ext. Ref',
          className: 'external_ref',
          name: 'external_ref',
          orderable: false,
        },
# 12
        {
          data: "technician_name",
          title: 'Technician',
          className: 'technician_name',
          name: 'technician_name',
          orderable: false,
          searchable: false
        },
# 13
        {
          data: "full_address",
          title: 'Address',
          className: 'full_address',
          name: 'full_address',
          orderable: false,
          searchable: false
        },
# 14
        {
          data: "scheduled_for",
          title: 'Scheduled For',
          className: 'scheduled_for',
          name: 'scheduled_for',
          orderable: false,
          searchable: true
        },
# 15
        {
          data: "completed_on",
          title: 'Completed On',
          className: 'completed_on',
          name: 'completed_on',
          orderable: false,
          searchable: true
        },
# 16
        {
          data: "employee_name",
          title: 'Employee',
          className: 'employee',
          name: 'employee_name',
          orderable: false,
          searchable: false
        },
# 17
        {
          data: "notes",
          title: 'Notes',
          className: 'notes',
          name: 'notes',
          orderable: false,
          searchable: false
        }

      ]

      fnRowCallback: (nRow, job, iDisplayIndex) ->
        e = new App.DataTableJobsFormater
        e.style(nRow, job)
    )

  $("a[href='#allJobs']").one 'shown.bs.tab', ->
    dataTable.ajax.reload()


  # enable chosen js
  $('.chosen-select').chosen
    allow_single_deselect: true
    no_results_text: 'No results matched'
    width: '200px'

  $('#customer_search').bind 'railsAutocomplete.select', (e, data)->
    $('#job-search-results').dataTable().api().ajax.reload()

#  $('#provider').on 'change', ->
#    $('#customer_filter_id').val('')
#    $('#customer_search').val('')
#    prov_id = $('#provider').val()
#    $('#customer_search').val('')
#    $('#customer_search').attr("data-ref-id", prov_id)
#    $('#job-search-results').dataTable().api().ajax.reload()

#  $('#affiliate').on 'change', ->
#    $('#customer_search').data('ref-id', $('#affiliate').val())
#    $('#job-search-results').dataTable().api().ajax.reload()

#  $('#subcontractor').on 'change', ->
#    $('#job-search-results').dataTable().api().ajax.reload()

  $('#clear-customer').live 'click', ->
    $('#customer_filter_id').val('')
    $('#customer_search').val('')
    $('#job-search-results').dataTable().api().ajax.reload()



  $('.download_csv').on 'click', (e)->
    e.preventDefault()
    window.location = Jobs.full_url()

  if $('#allJobs').is(':visible')
    dataTable.ajax.reload()

  $('.collapse.overlay').on {
    shown: ->
      $(this).css('overflow', 'initial')
    hide: ->
      $(this).css('overflow', 'hidden');
  }

  $('#load-state').click (e) ->
    e.preventDefault();
    autosave_state = false;
    dataTable.state.load()
    #    dataTable.columns.adjust().draw()
    dataTable.draw()
    drawVisibleColumnHeader(dataTable)
  #    $(dataTable.table().header()).html(dataTable.columns().visible().header())


  $('#save-state').click (e) ->
    e.preventDefault();
    autosave_state = false;
    localStorage.setItem('datatable-data' + localStorage.getItem('index'), JSON.stringify(dataTable.state()))

  $('#job-index-filters').on 'show', '.collapse', (e) ->
    $('#job-index-filters').find('.collapse.in').collapse('hide')

  App.JobIndex.filterView.filters = [
    statusFilter, billingStatusFilter, workStatusFilter, dateRange,
    completedDateRange, scheduledDateRange, startDateRange, techFilter,
    employeeFilter, contractorFilter, subconFilter,affiliateFilter ,tagsFilter,]

  App.JobIndex.filterView.rootElement = $('#filter-view')
  App.JobIndex.filterView.init()
  App.JobIndex.filterView.draw()


#drawVisibleColumnHeader = (dataTable)->
#  visible_cols = []
#  jQuery.each dataTable.table().columns().visible(), (i, visible) ->
#    if visible
#      visible_cols.push i
#  $(dataTable.table().header()).html(dataTable.columns(visible_cols).header())




