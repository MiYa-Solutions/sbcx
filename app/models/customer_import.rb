class CustomerImport < RecordsImport

  def static_attributes
    {
        'organization_id' => @user.organization_id
    }
  end

  def initialize(user, attributes = {})
    attributes[:klass] = 'Customer'
    super(user, attributes)
  end

  # def post_batch_load(batch)
  #   create_default_agreement(batch)
  # end

  protected

  def authorized_params(hash)
    PermittedParams.new(ActionController::Parameters.new(customer: hash), @user).customer
  end

  private

  def create_default_agreement(batch)
    batch.collect {|customer| customer.create_default_agreement }
  end

end