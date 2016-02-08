class App.JobStatusFilter extends App.MultiStatusFilter

  class: 'badge-success'
  placeholder_text: 'Select Statuses'
  label: =>
    'Status'

  options: [
    {id: 0, text: 'New'}
    {id: 1, text: 'Open'}
    {id: 2, text: 'Transferred'}
    {id: 3, text: 'Closed'}
    {id: 4, text: 'Canceled'}
    {id: 1201, text: 'Accepted'}
    {id: 1202, text: 'Rejected'}
  ]

