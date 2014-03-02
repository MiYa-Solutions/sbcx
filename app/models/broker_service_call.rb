class BrokerServiceCall < TransferredServiceCall
  extend CollectionStateMachine

  collection_status :prov_collection_status, 'prov_collection'
  collection_status :subcon_collection_status, 'subcon_collection'

end