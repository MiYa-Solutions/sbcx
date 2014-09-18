# comments.js.coffee
jQuery ->
  # Create a comment
#  $("#new_comment").on "ajax:success", (e, data, xhr)->
#    t = $(this).find('textarea')
#    t.removeClass('uneditable-input')
#    t.removeAttr('disabled', 'disabled')
#    t.val('')
#
#    $(xhr.responseText).hide().insertAfter($(this)).show('slow')

  $("#new_comment").on "ajax:beforeSend", (e, xhr, settings)->
    t = $(this).find('textarea')
    t.addClass('uneditable-input')
    t.attr('disabled', 'disabled')


  $(document)
  .on "ajax:beforeSend", ".comment", ->
    $(this).fadeTo('fast', 0.5)
  .on "ajax:success", ".comment", ->
    $(this).hide('fast')
  .on "ajax:error", ".comment", ->
    $(this).fadeTo('fast', 1)

