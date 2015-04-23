class App.DataTableJobsFormater
  constractor: ->

  style: (row, job) ->
    @color_cells(row, job)
    @format_money(row, job)
    @add_overdue_img(row, job)

  add_overdue_img: (row, job) ->
    if job['billing_status'] == 'overdue'
      img = HandlebarsTemplates['jobs/overdue_job']()
      if $('.customer', row).length > 0
        $('.customer', row).append(img)
      else
        $('td:last', row).append(img)

      $(img).tooltip()


  color_cells: (row, job)->
    @color_status_cell(row, job)
    @color_work_status_cell(row, job)

  color_status_cell: (row, job)->
    $('.status', row).addClass("job_status_#{job.status}")

  color_work_status_cell: (row, job)->
    $('.work_status', row).addClass("job_work_status_#{job.work_status}")

  format_money: (row, job) ->
    @format_customer_balance(row, job) if $('.customer_balance', row).length > 0
    @format_subcontractor_balance(row, job) if $('.subcontractor_balance', row).length > 0
    @format_contractor_balance(row, job) if $('.contractor_balance', row).length > 0
    @format_total_price(row, job) if $('.total_price', row).length > 0
    @format_my_profit(row, job) if $('.my_profit', row).length > 0
    @format_total_cost(row, job) if $('.total_cost', row).length > 0

  format_customer_balance: (row, job) ->
    @format_ccy(row, job, 'customer_balance')

  format_subcontractor_balance: (row, job) ->
    @format_ccy(row, job, 'subcontractor_balance')

  format_contractor_balance: (row, job) ->
    @format_ccy(row, job, 'contractor_balance')

  format_total_price: (row, job) ->
    @format_ccy(row, job, 'total_price')

  format_total_cost: (row, job) ->
    @format_ccy(row, job, 'total_cost')

  format_my_profit: (row, job) ->
    @format_ccy(row, job, 'my_profit')

  format_ccy: (row, job, field_name) ->
    amount = parseInt(job[field_name]) / 100
    ccy = job["#{field_name}_ccy_sym"]

    formated_amount = accounting.formatMoney(amount)
    $(".#{field_name}", row).text(formated_amount)
    if amount > 0.0
      $(".#{field_name}", row).addClass('green_amount')
    else if amount < 0
      $(".#{field_name}", row).addClass('red_amount')


$ ->
  $('a[data-toggle="tab"]').on 'shown.bs.tab', (e) ->
    localStorage.setItem('job_index/lastTab', $(e.target).attr('href'))

  last_tab = localStorage.getItem('job_index/lastTab')
  if last_tab
    $("a[href='#{last_tab}']").tab('show')
    $("a[href='#{last_tab}']").trigger('shown.bs.tab')
  else
    $("a[href='#newJobs']").tab('show')
    $("a[href='#newJobs']").trigger('shown.bs.tab')