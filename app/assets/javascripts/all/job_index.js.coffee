jQuery ->
  $('#myJobTab a:first').tab 'show'
  $('#job-search-results').dataTable
    sDom: "CW<'row-fluid'<'span6'T><'span6'f>r>tl<'row-fluid'<'span6'i><'span6'p>>"
    sPaginationType: "bootstrap"
    bProcessing: false
    bStateSave: false
    oTableTools:
      aButtons: ["copy", "print",
        sExtends: "collection"
        sButtonText: "Save <span class=\"caret\" />"
        aButtons: ["csv", "xls", "pdf"]
      ]
      sSwfPath: "copy_csv_xls_pdf.swf"
    oColumnFilterWidgets:
      aiExclude: [ 0, 1, 6, 7, 8, 9 ]

  $.datepicker.regional[""].dateFormat = 'MM dd, yy'
  $.datepicker.setDefaults($.datepicker.regional[''])

  $('#job-search-results').dataTable().columnFilter
    aoColumns: [

      type: "text"
      bRegex: true
      bSortCellsTop: true
      bSmart: true
    ,
      type: "date-range"
    ,
      type: null
    ,
      type: null
    ,
      type: null
    ,
      type: null
    ,
      type: "number-range"
    ,
      type: "number-range"
    ,
      type: "number-range"
    ,
      type: "number-range"

    ]

#  $('#job-search-results').dataTable().columnFilter
#    sPlaceHolder: "head:after"
#    bServerSide: true
#    sAjaxSource: "/service_calls/"
#    fnServerData: (sSource, aoData, fnCallback) ->
#      # Add some extra data to the sender
#      aoData.push
#        name: "affiliate_id"
#        value: $('#affiliate_id').val()
#      aoData.push
#        name: "customer_id"
#        value: $('#customer_id').val()
#      aoData.push
#        name: "account_id"
#        value: $('#account_id').val()
#      #            value: $('#get-entries-btn').data('account-id')
#      $.getJSON sSource, aoData, (json) ->
#        fnCallback json
