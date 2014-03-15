class BrokerServiceCall < TransferredServiceCall
  include CollectionStateMachine

  collection_status :subcon_collection_status, initial: :pending, namespace: 'subcon_collection'
  collection_status :prov_collection_status, initial: :pending, namespace: 'prov_collection'

end