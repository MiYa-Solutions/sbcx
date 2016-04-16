$ ->
  $('#search-results-table').dataTable
    sDom: "<'row-fluid'<'span12'f>r>t<'row-fluid'<'span6'i><'span6'p>>"
    sPaginationType: "bootstrap"
    bProcessing: true
    bStateSave: true
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
      aoData.push
        name: "table_type"
        value: 'job_search'
#            value: $('#get-entries-btn').data('account-id')
      $.getJSON sSource, aoData, (json) ->
          fnCallback json


  $('#search-results table tbody tr').live 'click', (e) ->
    $('#accounting_entry_ticket_ref_id').val( $(this).find('td:eq(0)').text())
    $('#ticket_search').modal('hide')


  $('#ticket_search').on 'shown.bs.modal', ->
    $('#search-results-table').dataTable().fnDraw()
    $('#ticket_search_header').text("Find Job For: " + $('#account').find(":selected").text())



