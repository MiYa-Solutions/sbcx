class SubconServiceCall < TransferredServiceCall
  # override the transfer method created by the status state_machine in TransferredServiceCall
  # and change self to a BrokerServiceCall
  def transfer
    SubconServiceCall.transaction do
      self.type = 'BrokerServiceCall'
      self.save!
      super
    end
  end
end