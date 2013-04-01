jQuery ->
  $('#entries_table').dataTable
    sDom: "<'row-fluid'<'span6'T><'span6'f>r>tl<'row-fluid'<'span6'i><'span6'p>>"
    sPaginationType: "bootstrap"
    iDisplayLength: 25
    oTableTools:
      aButtons: ["copy", "print",
        sExtends: "collection"
        sButtonText: "Save <span class=\"caret\" />"
        aButtons: ["csv", "xls", "pdf"]
      ]
    bProcessing: true
    bStateSave: true
    bServerSide: true
    sAjaxSource: $('#entries_table').data('source')
    fnServerData: (sSource, aoData, fnCallback) ->

      # Add some extra data to the sender
      aoData.push
        name: "accounting_entry[account_id]"
        value: $('#account').find(":selected").val()

      $.getJSON sSource, aoData, (json) ->
        fnCallback json

    fnRowCallback: (nRow, aData, iDisplayIndex) ->
      # Append the row id to allow automated testing
      $(nRow).attr('id', 'accounting_entry_' + aData[0])
      $('td:eq(3)', nRow).attr('id', 'entry_' + aData[0] + '_type')
      $('td:eq(4)', nRow).attr('id', 'entry_' + aData[0] + '_status')
      $('td:eq(5)', nRow).attr('id', 'entry_' + aData[0] + '_amount')
#      $(nRow).click ->
#        alert ('clicked row' + $(nRow).attr('id'))
  $('#entries_table').dataTable().columnFilter()
  $('#get-entries-btn').live 'click', (e) ->
    oTable = $('#entries_table').dataTable()
    oTable.fnDraw()

  # when changing the account selection - update all hidden fields
  $('#account').on 'change', ->
    new_acc = $('#account').find(":selected").val()
    $('#accounting_entry_account_id').val(new_acc)
    $('#account_id').val(new_acc)
    $('#accounting_entry_account_id').val(new_acc)
    $('#get-entries-btn').data('account-id', new_acc )
    $('#balance').text($('#account').find(":selected").data('balance'))

  $('#entries_table').dataTable.fnFilterOnReturn

  $('#account').val($('#get-entries-btn').data('account-id'))

  $('#new_accounting_entry').bind 'ajax:success', (xhr, response, status)->
    oTable = $('#entries_table').dataTable()
    oTable.fnDraw()

  $('#new_accounting_entry').bind 'ajax:error', (e, xhr, status, error)->
    $.each $.parseJSON(xhr.responseText), (attr, msg) ->
      switch attr
        when 'description'
          $('#accounting_entry_description').parent('div').addClass('control-group error')
          $("#accounting_entry_description").parent().append("<span class='alert-error'>#{msg}</span>")
        when 'ticket_ref_id'
          $('#accounting_entry_ticket_ref_id').parent('div').addClass('control-group error')
          $("#accounting_entry_ticket_ref_id").parent().append("<span class='alert-error'>#{msg}</span>")
        when 'amount'
          $('#accounting_entry_ticket_ref_id').parent('div').addClass('control-group error')
          $("#accounting_entry_ticket_ref_id").parent().append("<span class='alert-error'>#{msg}</span>")
        else
          $('#new_accounting_entry').prepend("<span class='alert-error'>#{attr} #{msg}</span>")


