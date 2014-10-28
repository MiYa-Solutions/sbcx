class EntryStyler
#  constructor: ->

  sanitize_actions: (row) ->
    row.actions.replace(/[{}]/g, "")

  color_cells: (row, entry)->
    $('td:eq(4)', row).addClass("entry_status_#{entry.status}")

  style: (row, entry) ->
    this.color_cells(row, entry)


jQuery ->
  $('#account').select2()
  $('table.entry_table').dataTable
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
    fnServerData: (sSource, aoData, fnCallback, settings) ->
      aoData.push
        name: "accounting_entry[account_id]"
        value: $('#account').find(":selected").val()

      $.getJSON sSource, aoData, (json) ->
        fnCallback json

    columns: [
      { data: "id" },
      { data: "created_at" },
      { data: "ref_id" },
      { data: 'human_type' },
      { data: "human_status" },
      { data: "amount" },
      { data: "collector_name" },
      { data: "notes" },
      { data: "actions" }
    ]
    createdRow: (row, data, dataIndex) ->
      forms = $(row).find('.entry_form')
      $(forms).on 'ajax:success', {rowIndex: dataIndex}, (e, data, status, xhr) ->
        table = $(this).closest('table').dataTable().api()
        row_to_update = table.row(e.data.rowIndex)
        row_to_update.data(data)
        table.draw()

      $(forms).on 'ajax:complete', {row: dataIndex},  (e, xhr) ->
        table = $(this).closest('table').dataTable().api()
        row_to_update = table.row(e.data.rowIndex)
        $(row_to_update.node()).find('input[type=submit]').removeAttr("disabled")


      $(forms).on 'ajax:beforeSend',{rowIndex: dataIndex} ,(e, xhr, settings) ->
#        $(this).find('input[type=submit]').attr('disabled', 'disabled')
        table = $(this).closest('table').dataTable().api()
        row_to_update = table.row(e.data.rowIndex)
        $(row_to_update.node()).find('input[type=submit]').attr('disabled', 'disabled')

      $(forms).on 'ajax:error', (e, xhr, error) ->


    fnRowCallback: (nRow, entry, iDisplayIndex) ->
      # Append the row id to allow automated testing
      e = new EntryStyler
      $(nRow).attr('id', 'accounting_entry_' +  entry.id)
      $('td:eq(3)', nRow).attr('id', 'entry_' + entry.id + '_type')
      $('td:eq(4)', nRow).attr('id', 'entry_' + entry.id + '_status')
      $('td:eq(5)', nRow).attr('id', 'entry_' + entry.id + '_amount')
      e.style(nRow, entry)

  #      $('td:eq(7)', nRow).html(sanitize_actions(aData))

  $.extend $.fn.dataTableExt.oStdClasses,
    sWrapper: "dataTables_wrapper form-inline"

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




