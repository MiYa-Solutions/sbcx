jQuery ->
  $('#myJobTab a:first').tab 'show'
  $('#job-search-results').dataTable
    sDom: "<'row-fluid'<'span6'T><'span6'f>r>tl<'row-fluid'<'span6'i><'span6'p>>"
    sPaginationType: "bootstrap"
    bProcessing: true
    bStateSave: true
    oTableTools:
      aButtons: ["copy", "print",
        sExtends: "collection"
        sButtonText: "Save <span class=\"caret\" />"
        aButtons: ["csv", "xls", "pdf"]
      ]

    bServerSide: true
    sAjaxSource: "/service_calls/"
    fnServerData: (sSource, aoData, fnCallback) ->
      # Add some extra data to the sender
      aoData.push
        name: "affiliate_id"
        value: $('#affiliate_id').val()
      aoData.push
        name: "customer_id"
        value: $('#customer_id').val()
      aoData.push
        name: "account_id"
        value: $('#account_id').val()
      #            value: $('#get-entries-btn').data('account-id')
      $.getJSON sSource, aoData, (json) ->
        fnCallback json
