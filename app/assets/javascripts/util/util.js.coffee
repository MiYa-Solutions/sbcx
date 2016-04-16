Array::sumObjProp = (prop) ->
  total = 0
  i = 0
  _len = @length
  while i < _len
    total += @[i][prop]
    i++
  total
