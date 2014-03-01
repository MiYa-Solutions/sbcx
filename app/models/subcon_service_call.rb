class SubconServiceCall < TransferredServiceCall
  def transfer
    SubconServiceCall.transaction do
      self.type = 'BrokerServiceCall'
      self.save!
      super
    end
  end
end