jQuery ->
  $('#bom_material_name').autocomplete
    source: $('#bom_material_name').data('autocomplete-source')