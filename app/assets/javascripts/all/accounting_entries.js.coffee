sanitize_actions = (row) ->
  row.actions.replace(/[{}]/g, "")
#  row.actions.substring(1,row.actions.length-1)

jQuery ->
  $('#account').select2()
  $('#entries_table').dataTable
    sDom: "<'row-fluid'<'span6'T><'span6'f>r>tl<'row-fluid'<'span6'i><'span6'p>>"
#    sDom: "<'row'<'span6'l><'span6'f>r>t<'row'<'span6'i><'span6'p>>"
    sPaginationType: "bootstrap"
    iDisplayLength: 25
    oTableTools:
      aButtons: ["copy", "print",
        sExtends: "collection"
        sButtonText: "Save <span class=\"caret\" />"
        aButtons: ["csv", "xls", "pdf"]
      ],
      sSwfPath: "assets/dataTables/extras/swf/copy_csv_xls_pdf.swf"
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

    columns: [
      { data: "id" },
      { data: "created_at" },
      { data: "ref_id" },
      { data: 'type' },
      { data: "status" },
      { data: "amount" },
      { data: "balance" }
      { data: "actions" }
    ]
    createdRow: (row, data, dataIndex) ->
      forms = $(row).find('.entry_form')
      $(forms).on 'ajax:success', {rowIndex: dataIndex}, (e, data, status, xhr) ->
        table = $('#entries_table').dataTable().api()
        row_to_update = table.row(e.data.rowIndex)
        row_to_update.data(data)
        table.draw()

      $(forms).on 'ajax:complete', {row: dataIndex},  (e, xhr) ->
        table = $('#entries_table').dataTable().api()
        row_to_update = table.row(e.data.rowIndex)
        $(row_to_update.node()).find('input[type=submit]').removeAttr("disabled")


      $(forms).on 'ajax:beforeSend',{rowIndex: dataIndex} ,(e, xhr, settings) ->
#        $(this).find('input[type=submit]').attr('disabled', 'disabled')
        table = $('#entries_table').dataTable().api()
        row_to_update = table.row(e.data.rowIndex)
        opts =
          lines: 13, #// The number of lines to draw
          length: 20, #// The length of each line
          width: 3, #// The line thickness
          radius: 30, #// The radius of the inner circle
          corners: 1, #// Corner roundness (0..1)
          rotate: 0, #// The rotation offset
          direction: 1, #// 1: clockwise, -1: counterclockwise
          color: '#000', #// #rgb or #rrggbb or array of colors
          speed: 1, #// Rounds per second
          trail: 60, #// Afterglow percentage
          shadow: true, #// Whether to render a shadow
          hwaccel: true, #// Whether to use hardware acceleration
          className: 'spinner', #// The CSS class to assign to the spinner
          zIndex: 2e9, #// The z-index (defaults to 2000000000)
          top: '50%', #// Top position relative to parent
          left: '50%' #// Left position relative to parent

        new Spinner(opts).spin($(row_to_update.node()).find('input[type=submit]').parent)
        $(row_to_update.node()).find('input[type=submit]').attr('disabled', 'disabled')

      $(forms).on 'ajax:error', (e, xhr, error) ->


    fnRowCallback: (nRow, aData, iDisplayIndex) ->
      # Append the row id to allow automated testing
      $(nRow).attr('id', 'accounting_entry_' + aData[0])
      $('td:eq(3)', nRow).attr('id', 'entry_' + aData[0] + '_type')
      $('td:eq(4)', nRow).attr('id', 'entry_' + aData[0] + '_status')
      $('td:eq(5)', nRow).attr('id', 'entry_' + aData[0] + '_amount')
#      $('td:eq(7)', nRow).html(sanitize_actions(aData))

  $.extend $.fn.dataTableExt.oStdClasses,
    sWrapper: "dataTables_wrapper form-inline"

#  $('.entry_form').on 'ajax:success', (data, status, xhr) ->
#    alert('finished ajax for '+'entry '+ data.id)


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
    $('#get-entries-btn').data('account-id', new_acc)
    $('#balance').text($('#account').find(":selected").data('balance'))
    if $('#get-entries-btn').data('account-id') != ''
      $('#add_new_entry').show()
    else
      $('#add_new_entry').hide()


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

  if $('#get-entries-btn').data('account-id') == ''
    $('#add_new_entry').hide()
  else if $('#get-entries-btn').data('account-id') != undefined
    oTable = $('#entries_table').dataTable()
    oTable.fnDraw()

  $('#entries_table').on 'xhr.dt', (e, settings, json) ->
    alert('finished ajax for table')
  $(document).on( 'ajax:success', '.entry_btn', (data, status, xhr) ->
    alert('finished ajax for '+'entry '+ data.id))




