module PaymentHelper
  def payment_types
    Payment.subclasses.map { |subclass| payment_option(subclass) }
  end

  def payment_option(klass)

    [
        klass.name.titleize,
        klass.name.underscore,
    ]

  end

end
