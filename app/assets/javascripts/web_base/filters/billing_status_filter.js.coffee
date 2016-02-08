class App.BillingStatusFilter extends App.MultiStatusFilter

  placeholder_text: 'Select Billing Statuses'
  label: =>
    'Billing Status'

  options: [
    {id: 4100, text: 'Pending'}
    {id: 4103, text: 'Overdue'}
    {id: 4104, text: 'Paid'}
    {id: 4109, text: 'Rejected'}
    {id: 4110, text: 'Partially Collected'}
    {id: 4102, text: 'Collected'}
    {id: 4114, text: 'In Process'}
    {id: 4113, text: 'Over Paid'}
  ]

