$.rails.allowAction = (element) ->
  # The message is something like "Are you sure?"
  message = element.data('confirm')
  # If there's no message, there's no data-confirm attribute, 
  # which means there's nothing to confirm
  return true unless message
  # Clone the clicked element (probably a delete link) so we can use it in the dialog box.
  if element.prop('tagName') == 'INPUT'
    $link = element.closest('form').clone()
    .removeAttr('class')
    .removeAttr('id')
    .addClass('id')
    .wrap("<li></li>").parent()


    $link.children('form').children('input')
    .removeAttr('data-confirm')
    .removeAttr('class')
    .removeAttr('id')
    .addClass('btn-danger')
    .addClass('btn')

  else
    $link = element.clone()
    # We don't necessarily want the same styling as the original link/button.
    .removeAttr('class')
    # We don't want to pop up another confirmation (recursion)
    .removeAttr('data-confirm')
    # We want a button
    .addClass('btn').addClass('btn-danger')
    # We want it to sound confirmy
    .html("Yes")

  # Create the modal box with the message

  modal_html = HandlebarsTemplates['confirmation_modal'](message: message)
  $modal_html = $(modal_html)
  # Add the new button to the modal box
  $modal_html.find('.modal-footer ul').append($link)
  # Pop it up
  $modal_html.modal()
  # Prevent the original link from working
  $('#dismiss-confirmation-modal').click ->
    $('#confirmation_modal').modal('hide')
    $('#confirmation_modal').remove()

  return false