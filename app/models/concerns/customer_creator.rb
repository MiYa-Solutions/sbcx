module CustomerCreator
  extend ActiveSupport::Concern

  included do |base|
    belongs_to :customer, :inverse_of => base.name.underscore.pluralize.to_sym
    attr_accessor :new_customer
    attr_writer :customer_name
    before_validation :create_customer, if: ->(tkt) { tkt.customer_id.nil? }

  end

  def create_customer
    if provider
      self.customer = self.provider.customers.new(customer_attributes) if customer_name.present? && customer.nil?

    else
      self.customer = self.organization.customers.new(customer_attributes) if customer_name.present? && customer.nil?
    end
  end

  def customer_name
    self.customer_id ? self.customer.name : @customer_name
  end

  # def provider
  #   raise NotImplementedError.new('CustomerCreator depends on the including method to implement provider')
  # end

  protected

  def customer_attributes
    { name: customer_name }

  end

end