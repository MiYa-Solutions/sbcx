class String
  def is_a_number?
    self =~ /\A[-+]?[0-9]*\.?[0-9]+\Z/ ? true : false
  end
end