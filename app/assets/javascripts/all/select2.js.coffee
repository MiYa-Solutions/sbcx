$ ->
  $('.select2').each ->
    required = Boolean($(this).attr('required'))

    $(this).select2
      allowClear: !required
