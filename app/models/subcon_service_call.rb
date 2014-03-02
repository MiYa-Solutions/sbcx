class SubconServiceCall < TransferredServiceCall
  extend CollectionStateMachine

  after_initialize :set_prov_collection_status

  collection_status :prov_collection_status, 'prov_collection'

  # override the transfer method created by the status state_machine in TransferredServiceCall
  # and change self to a BrokerServiceCall
  def transfer(*)
    self.type = 'BrokerServiceCall'
    super
    Rails.logger.debug {"Executed overridden transfer for SubconServiceCall.\nself.type: #{self.type}\nself.status: #{self.status_name}"}
  end

  private

  def set_prov_collection_status
    self.prov_collection_status = CollectionStateMachine::STATUS_PENDING
  end
end