shared_context 'when starting the job' do |job_to_start|
  before do
    job_to_start.update_attributes(work_status_event: 'start')
  end
end

shared_context 'when completing the job' do |job_to_complete|
  before do
    job_to_complete.update_attributes(work_status_event: 'complete')
  end
end

shared_context 'when adding boms' do |job_for_boms, boms_to_add|

  before do
    boms_to_add.each do |b|
      add_bom_to_job job_for_boms, cost:     b[:cost],
                                   price:    b[:price],
                                   quantity: b[:quantity],
                                   buyer:    b[:buyer],
                                   material: b[:material]
    end

  end
end

shared_context 'when collecting a payment' do |job_to_collect, collection_event, payment_type, payment_amount, payment_collector |

  before do
    job_to_collect.update_attributes(billing_status_event: collection_event,
                                     payment_type:         payment_type,
                                     payment_amount:       payment_amount.to_s,
                                     collector:            payment_collector)
    job_to_collect.payment_amount = nil # to simulate a new user request by clearing virtual attr
  end
end

shared_context 'when closing the job' do |job_to_close|
  before do
    job_to_close.close!
  end
end

shared_context 'when invoicing' do |job_to_invoice|
  before do
    job_to_invoice.invoice_payment!
  end
end


