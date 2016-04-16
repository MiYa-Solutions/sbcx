module PaymentHelper
  def payment_types
    Payment.subclasses.map { |subclass| payment_option(subclass) }
  end

  def payment_option(klass)

    [
        klass.model_name.human,
        klass.name.underscore,
    ]

  end

end
