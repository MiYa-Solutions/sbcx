#class AreaCalculator
#
#  area_view: null
#  popover: null
#  constructor: (@element, @output) ->
#    @area_view = HandlebarsTemplates['service_calls/area_calculator']()
#    @popover = @build_popover
#
#  build_popover: ->
#    @element.popover(
#      html: true
#      trigger: 'manual'
#      title: 'Area Calculator'
#      placement: 'top'
#      content: @area_view
#    )
#
#  draw: ->
#    $(@element).click (event) =>
#      @popover('toggle')
##      $(event.target).popover('toggle')
#      $('#area-calc-form').parsley()
#
#      $('#area-calc-btn').on 'click', (event) =>
#        if $('#area-calc-form').parsley().isValid()
#          $(@output).val(@calculate_area($('#area-calc-fwidth').val(), $('#area-calc-iwidth').val(), $('#area-calc-flength').val(), $('#area-calc-ilength').val()))
#          @element.popover('toggle')
#
#
#  calculate_area: (fwidth = 0, iwidth = 0, flength = 0, ilength = 0) ->
#    (((fwidth * 12) + parseFloat(iwidth)) * ((flength * 12) + parseFloat(ilength))) / 144.0
#
#
#$ ->
#  new AreaCalculator($('#area-calc'), $('#bom_quantity') ).draw()
#
#
#

class AreaCalculator

  constructor: (@element, @output) ->
    $('#area-calc-form').parsley(
      errorClass: 'error'
      successClass: 'success'
    )

    @desc_element = $('#bom_description')

    $('#area-calc-btn').on 'click', (event) =>
      @fwidth = $('#area-calc-fwidth').val()
      @iwidth = $('#area-calc-iwidth').val()
      @flength = $('#area-calc-flength').val()
      @ilength = $('#area-calc-ilength').val()

      if $('#area-calc-form').parsley().isValid()
        res = @calculate_area(@fwidth, @iwidth, @flength, @ilength)
        $(@output).val(Math.round(res * 1000 ) / 1000)
        $(@desc_element).val($(@desc_element).val() + @size_sting())
        $('#area_calculator').modal('toggle')


  calculate_area: (fwidth = 0, iwidth = 0, flength = 0, ilength = 0) ->
    (((fwidth * 12) + parseFloat(iwidth)) * ((flength * 12) + parseFloat(ilength))) / 144.0

  size_sting: ->
    ' (' + @fwidth + '\'' + @iwidth + '\" x ' + @flength + '\'' + @ilength + '\")'


$ ->
  new AreaCalculator($('#area-calc'), $('#bom_quantity') )



