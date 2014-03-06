class SubconServiceCall < TransferredServiceCall
  include CollectionStateMachine

  collection_status :prov_collection_status, initial: :pending, namespace: 'prov_collection'

  # override the transfer method created by the status state_machine in TransferredServiceCall
  # and change self to a BrokerServiceCall
  def transfer(*)
    self.type = 'BrokerServiceCall'
    super
    Rails.logger.debug {"Executed overridden transfer for SubconServiceCall.\nself.type: #{self.type}\nself.status: #{self.status_name}"}
  end

end