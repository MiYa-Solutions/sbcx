$ ->
#  $('#ticket_search_form').bind "ajax:success", (evt, data, status, xhr)->
#    $('div#search-results table').show()
#    size = data.length
#    i = 0
#    while i < size
#      $('div#search-results table > tbody:last').append( "<tr id='ticket_#{data[i].id}'><td>#{data[i].ref_id}</td><td>#{data[i].customer_id}</td></tr>")
#      i++
  $('#ticket-search-button').click (e)->
    $('div#search-results table').show()

    $('#search-results-table').dataTable
      sDom: "<'row-fluid'<'span12'f>r>t<'row-fluid'<'span6'i><'span6'p>>"


      #      sDom: "<'row-fluid'<'span6'T><'span6'f>r>tl<'row-fluid'<'span6'i><'span6'p>>"

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
  #            value: $('#get-entries-btn').data('account-id')
        $.getJSON sSource, aoData, (json) ->
            fnCallback json


    $('#ticket-search-button').unbind('click')
    $('#ticket-search-button').click (e)->
      $('#search-results-table').dataTable().fnDraw()

  $('#search-results table tbody tr').live 'click', (e) ->
    $('#accounting_entry_ticket_ref_id').val( $(this).find('td:eq(0)').text())
    $('#ticket_search').modal('hide')


