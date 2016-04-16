String.prototype.titleize = ->
  return this.charAt(0).toUpperCase() + this.slice(1)

App.csrf_token =  ->
  $('meta[name="csrf-token"]').attr('content')
