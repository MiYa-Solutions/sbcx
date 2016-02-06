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
    dateRange = new App.DateRangeFilter({element: $('#created-at-range'), table: $('#job-search-results'), btn: $('#clear-created-range')})
    startDateRange = new App.DateRangeFilter({element: $('#started-on-range'), table: $('#job-search-results'), btn: $('#clear-started-range')})
    scheduledDateRange = new App.DateRangeFilter({element: $('#scheduled-for-range'), table: $('#job-search-results'), btn: $('#clear-scheduled-range')})
    completedDateRange = new App.DateRangeFilter({element: $('#completed-at-range'), table: $('#job-search-results'), btn: $('#clear-completed-range')})
    employeeFilter = new App.EmployeeFilter({table: $('#job-search-results'), element: $('#employee_id'), btn: $('#clear-employee')})
    techFilter = new App.TechnicianFilter({table: $('#job-search-results'),element:  $('#technician_id'), btn: $('#clear-tech')})
    tagsFilter = new App.Filter({table: $('#job-search-results'), element: $('#tags'),btn: $('#clear-tags')})
    statusFilter = new App.JobStatusFilter({ table: $('#job-search-results'), element: $('#status'), btn: $('#clear-status')})
    workStatusFilter = new App.WorkStatusFilter({table: $('#job-search-results'), element: $('#work_status'), btn: $('#clear-work-status')})
    billingStatusFilter = new App.BillingStatusFilter({table: $('#job-search-results'), element: $('#billing_status'), btn: $('#clear-billing-status')})
    contractorFilter = new App.ContractorFilter({table: $('#job-search-results'),element:  $('#provider'), btn: $('#clear-provider')})
    subconFilter = new App.SubcontractorFilter({table: $('#job-search-results'), element: $('#subcontractor'), btn: $('#clear-subcontractor')})
    affiliateFilter = new App.AffiliateFilter({table: $('#job-search-results'), element: $('#affiliate'), btn: $('#clear-affiliate')})
    customerFilter = new App.CustomerFilter({table: $('#job-search-results'), element: $('#customer_search'), id_field: $('#customer_filter_id'), btn:$('#clear-customer')})


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
          d.filters.customer_id = customerFilter.getVal()
          d.filters.provider_id = contractorFilter.getVal()
          d.filters.subcontractor_id = subconFilter.getVal()
          d.filters.affiliate_id = affiliateFilter.getVal()
          d.filters.billing_status = billingStatusFilter.getVal()
          d.filters.work_status = workStatusFilter.getVal()
          d.filters.tags = tagsFilter.getVal()
          return

      fnStateSaveParams: (oSettings, oData) ->
        oData.filters = {}
        oData.filters.customer_id = customerFilter.getVal()
        oData.filters.from_date = dateRange.startDate()
        oData.filters.to_date = dateRange.endDate()
        oData.filters.started_from_date = startDateRange.startDate()
        oData.filters.started_to_date = startDateRange.endDate()
        oData.filters.scheduled_from_date = scheduledDateRange.startDate()
        oData.filters.scheduled_to_date = scheduledDateRange.endDate()
        oData.filters.completed_from_date = completedDateRange.startDate()
        oData.filters.completed_to_date = completedDateRange.endDate()
        oData.filters.customer_name = customerFilter.getText()
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
        customerFilter.setValNoReload(oData.filters.customer_name, oData.filters.customer_id)
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
    completedDateRange, scheduledDateRange, startDateRange, customerFilter, techFilter,
    employeeFilter, contractorFilter, subconFilter,affiliateFilter ,tagsFilter,]

  App.JobIndex.filterView.rootElement = $('#filter-view')
  App.JobIndex.filterView.init()
  App.JobIndex.filterView.draw()



