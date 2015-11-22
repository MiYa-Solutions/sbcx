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

  private

  def create_default_agreement(batch)
    batch.collect {|customer| customer.create_default_agreement }
  end

end