class FixCompletedJobs < ActiveRecord::Migration
  def up
    Ticket.where(:work_status => ServiceCall::WORK_STATUS_DONE, billing_status: CustomerJobBilling::STATUS_COLLECTED).each do |t|
      t.billing_status = CustomerJobBilling::STATUS_PAID if t.fully_cleared?
      t.save!
    end
  end

  def down
  end
end
