jQuery ->
  $.fn.editable.defaults.mode = "popover"
  $("#tags_list").editable
    ajaxOptions:
      beforeSend: (e, xhr, settings) ->
        xhr.data = "service_call[tag_list]=#{$('input.input-medium').val()}"
    placement: "right"
    select2:
      tags: $('#service_call_tag_list').data('tags') #[$('#tags-editable-1').data('value')]
      val: $('#service_call_tag_list').val()
      tokenSeparators: [",", " "]

    display: (value) ->
      disp = []
      $.each value, (i) ->

        # value[i] needs to have its HTML stripped, as every time it's read, it contains
        # the HTML markup. If we don't strip it first, markup will recursively be added
        # every time we open the edit widget and submit new values.
        disp[i] = "<span class='label'>" + $("<p>" + value[i] + "</p>").text() + "</span>"

      $(this).html disp.join(" ")

  $("#tags_list").on "shown", ->
    editable = $(this).data("editable")
    value = editable.value
    $.each value, (i) ->
      value[i] = $("<p>" + value[i] + "</p>").text()


  $("[id^=\"tags-edit-\"]").click (e) ->
    e.stopPropagation()
    e.preventDefault()
    $("#" + $(this).data("editable")).editable "toggle"

  $('#service_call_tag_list').select2
    tags: $('#service_call_tag_list').data('tags')


#  # connecting select2 to the appropriate hooks:
#  #
#  # hard case: best_in_place's select
#
#  # first, find the mount point
#  $('body').on 'best_in_place:activate', '.best_in_place', ->
#
#    # second, attach empty update() to `this` to screen the downstream calls
#    # which otherwise will cause an error
#    @update = ->
#
#      # now unbind `blur` from the <select> and bind it to the downstream
#      # best_in_place's handler; this prevents the immediate select2's
#      # destruction since clicking on it would cause `blur` on the downstream
#      # best_in_place
#    $(@).find('service_call_tags').select2(tags: ['1', '2', '3'])
#      .unbind('blur').bind('blur', {editor: @}, BestInPlaceEditor.forms.select.blurHandler)
