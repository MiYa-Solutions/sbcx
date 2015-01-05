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
        $('#area_calculator').popup('close')


  calculate_area: (fwidth = 0, iwidth = 0, flength = 0, ilength = 0) ->
    (((fwidth * 12) + parseFloat(iwidth)) * ((flength * 12) + parseFloat(ilength))) / 144.0

  size_sting: ->
    ' (' + @fwidth + '\'' + @iwidth + '\" x ' + @flength + '\'' + @ilength + '\")'


$ ->
  new AreaCalculator($('#area-calc'), $('#bom_quantity') )



