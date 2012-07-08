$ ->
  $('select#organization_country').change (event) ->
    select_wrapper = $('#state_code_wrapper')

    $('select', select_wrapper).attr("disabled", "disabled")

    country_code = $(this).val()

    url = "/region_select/subregion_options?parent_region=#{country_code}"
    select_wrapper.load(url)
    $('select', select_wrapper).attr("disabled", "enabled")

# locale settings - not needed at this point. To see a demo of Carmen go to http://carmen-rails-demo.herokuapp.com/
#  $('select#locale').change (event) ->
#    $(@).closest('form').submit()