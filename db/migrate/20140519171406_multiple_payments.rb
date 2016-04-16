class MultiplePayments < ActiveRecord::Migration
  def up
    MyServiceCall.all.each do |job|
      job.billing_status           = new_billing_status(job)
      job.subcon_collection_status = new_subcon_collection_status(job)

      Ticket.transaction do
        job.save!
        update_entries(job)
      end
    end

    TransferredServiceCall.all.each do |job|

      case job.my_role
        when :subcon
          job.prov_collection_status = new_prov_collection_status(job)
          job.billing_status = 0
          job.type           = 'SubconServiceCall'
        when :broker
          job.subcon_collection_status = new_subcon_collection_status(job)
          job.prov_collection_status = new_prov_collection_status(job)
          job.billing_status = 0
          job.type           = 'BrokerServiceCall'
        else
          raise "Unexpected ticket my_role: #{job.my_role}"

      end
      Ticket.transaction do
        job.save! if job.changed?
        update_entries(job)
      end
    end

    CollectionEntry.all.each do |e|
      if e.collector.nil?
        e.collector = e.account.organization
        e.save!
      end
    end

    CustomerPayment.all.each do |e|
      if e.collector.nil?
        e.collector = e.account.organization
        if e.ticket.nil?
          e.destroy
        else
          e.save!
        end

      end
    end


  end

  def down
  end


  def new_billing_status(job)

    map = {
        # statuses in upgrade version MyServiceCall

        # BILLING_STATUS_PENDING = 4100
        4100 => CustomerJobBilling::STATUS_PENDING,
        # BILLING_STATUS_INVOICED               = 4101
        4101 => CustomerJobBilling::STATUS_PENDING,
        # BILLING_STATUS_COLLECTED_BY_EMPLOYEE  = 4102
        4102 => CustomerJobBilling::STATUS_COLLECTED,
        # BILLING_STATUS_OVERDUE                = 4103
        4103 => CustomerJobBilling::STATUS_OVERDUE,
        # BILLING_STATUS_PAID                   = 4104
        4104 => CustomerJobBilling::STATUS_COLLECTED,
        # BILLING_STATUS_INVOICED_BY_SUBCON     = 4105
        4105 => CustomerJobBilling::STATUS_PENDING,
        # BILLING_STATUS_COLLECTED_BY_SUBCON    = 4106
        4106 => CustomerJobBilling::STATUS_COLLECTED,
        # BILLING_STATUS_SUBCON_CLAIM_DEPOSITED = 4107
        4107 => CustomerJobBilling::STATUS_COLLECTED,
        # BILLING_STATUS_CLEARED                = 4108
        4108 => CustomerJobBilling::STATUS_PAID,
        # BILLING_STATUS_REJECTED               = 4109
        4109 => CustomerJobBilling::STATUS_REJECTED,

        # TransferredServiceCall

        # BILLING_STATUS_NA                     = 4200
        4200 => nil,
        # BILLING_STATUS_PENDING                = 4201
        4201 => CustomerJobBilling::STATUS_PENDING,
        # BILLING_STATUS_INVOICED               = 4202
        4202 => CustomerJobBilling::STATUS_PENDING,
        # BILLING_STATUS_COLLECTED_BY_EMPLOYEE  = 4203
        4203 => CustomerJobBilling::STATUS_COLLECTED,
        # BILLING_STATUS_COLLECTED              = 4204
        4204 => CustomerJobBilling::STATUS_COLLECTED,
        # BILLING_STATUS_DEPOSITED_TO_PROV      = 4205
        4205 => CustomerJobBilling::STATUS_COLLECTED,
        # BILLING_STATUS_DEPOSITED              = 4206
        4206 => CustomerJobBilling::STATUS_COLLECTED,
        # BILLING_STATUS_INVOICED_BY_SUBCON     = 4207
        4207 => CustomerJobBilling::STATUS_COLLECTED,
        # BILLING_STATUS_COLLECTED_BY_SUBCON    = 4208
        4208 => CustomerJobBilling::STATUS_COLLECTED,
        # BILLING_STATUS_SUBCON_CLAIM_DEPOSITED = 4209
        4209 => CustomerJobBilling::STATUS_COLLECTED,
        # BILLING_STATUS_INVOICED_BY_PROV       = 4210
        4210 => CustomerJobBilling::STATUS_PENDING
    }

    map[job.billing_status]
  end

  def new_prov_collection_status(job)

    map = {
        # TransferredServiceCall

        # BILLING_STATUS_NA                     = 4200
        4200 => nil,
        # BILLING_STATUS_PENDING                = 4201
        4201 => CollectionStateMachine::STATUS_PENDING,
        # BILLING_STATUS_INVOICED               = 4202
        4202 => CollectionStateMachine::STATUS_PENDING,
        # BILLING_STATUS_COLLECTED_BY_EMPLOYEE  = 4203
        4203 => CollectionStateMachine::STATUS_PENDING,
        # BILLING_STATUS_COLLECTED              = 4204
        4204 => CollectionStateMachine::STATUS_PENDING,
        # BILLING_STATUS_DEPOSITED_TO_PROV      = 4205
        4205 => CollectionStateMachine::STATUS_IS_DEPOSITED,
        # BILLING_STATUS_DEPOSITED              = 4206
        4206 => CollectionStateMachine::STATUS_DEPOSITED,
        # BILLING_STATUS_INVOICED_BY_SUBCON     = 4207
        4207 => CollectionStateMachine::STATUS_PENDING,
        # BILLING_STATUS_COLLECTED_BY_SUBCON    = 4208
        4208 => CollectionStateMachine::STATUS_PENDING,
        # BILLING_STATUS_SUBCON_CLAIM_DEPOSITED = 4209
        4209 => CollectionStateMachine::STATUS_PENDING,
        # BILLING_STATUS_INVOICED_BY_PROV       = 4210
        4210 => CollectionStateMachine::STATUS_PENDING
    }

    job.allow_collection? ? map[job.billing_status] : CollectionStateMachine::STATUS_NA
  end

  def new_subcon_collection_status(job)
    map = {
        # statuses in upgrade version MyServiceCall

        # BILLING_STATUS_PENDING = 4100
        4100 => CollectionStateMachine::STATUS_PENDING,
        # BILLING_STATUS_INVOICED               = 4101
        4101 => CollectionStateMachine::STATUS_PENDING,
        # BILLING_STATUS_COLLECTED_BY_EMPLOYEE  = 4102
        4102 => CollectionStateMachine::STATUS_PENDING,
        # BILLING_STATUS_OVERDUE                = 4103
        4103 => CollectionStateMachine::STATUS_PENDING,
        # BILLING_STATUS_PAID                   = 4104
        4104 => CollectionStateMachine::STATUS_PENDING,
        # BILLING_STATUS_INVOICED_BY_SUBCON     = 4105
        4105 => CollectionStateMachine::STATUS_PENDING,
        # BILLING_STATUS_COLLECTED_BY_SUBCON    = 4106
        4106 => CollectionStateMachine::STATUS_COLLECTED,
        # BILLING_STATUS_SUBCON_CLAIM_DEPOSITED = 4107
        4107 => CollectionStateMachine::STATUS_IS_DEPOSITED,
        # BILLING_STATUS_CLEARED                = 4108
        4108 => CollectionStateMachine::STATUS_DEPOSITED,
        # BILLING_STATUS_REJECTED               = 4109
        4109 => CollectionStateMachine::STATUS_PENDING,

        # TransferredServiceCall

        # BILLING_STATUS_NA                     = 4200
        4200 => nil,
        # BILLING_STATUS_PENDING                = 4201
        4201 => CollectionStateMachine::STATUS_PENDING,
        # BILLING_STATUS_INVOICED               = 4202
        4202 => CollectionStateMachine::STATUS_PENDING,
        # BILLING_STATUS_COLLECTED_BY_EMPLOYEE  = 4203
        4203 => CollectionStateMachine::STATUS_PENDING,
        # BILLING_STATUS_COLLECTED              = 4204
        4204 => CollectionStateMachine::STATUS_COLLECTED,
        # BILLING_STATUS_DEPOSITED_TO_PROV      = 4205
        4205 => CollectionStateMachine::STATUS_IS_DEPOSITED,
        # BILLING_STATUS_DEPOSITED              = 4206
        4206 => CollectionStateMachine::STATUS_DEPOSITED,
        # BILLING_STATUS_INVOICED_BY_SUBCON     = 4207
        4207 => CollectionStateMachine::STATUS_PENDING,
        # BILLING_STATUS_COLLECTED_BY_SUBCON    = 4208
        4208 => CollectionStateMachine::STATUS_COLLECTED,
        # BILLING_STATUS_SUBCON_CLAIM_DEPOSITED = 4209
        4209 => CollectionStateMachine::STATUS_IS_DEPOSITED,
        # BILLING_STATUS_INVOICED_BY_PROV       = 4210
        4210 => CollectionStateMachine::STATUS_PENDING
    }

    job.subcontractor ? map[job.billing_status] : CollectionStateMachine::STATUS_NA

  end

  def update_entries(job)
    entries = job.entries.where(type: ['MaterialReimbursement', 'MaterialReimbursementToCparty', 'PaymentToSubcontractor', 'IncomeFromProvider','CanceledJobAdjustment']).all
    entries.each do |e|
      e.status = AccountingEntry::STATUS_CLEARED
      e.save!
    end
  end
end
