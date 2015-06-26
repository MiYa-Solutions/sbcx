module Statementable
  extend ActiveSupport::Concern

  included do

  end

  def statementable_tickets
    completed_open_jobs + adv_payment_jobs + open_adj_entries_jobs
  end

  def completed_open_jobs
    self.tickets.where(work_status: ServiceCall::WORK_STATUS_DONE).all
  end

  def adv_payment_jobs
    []
    # self.tickets.where(work_status: ServiceCall::WORK_STATUS_DONE).all
  end

  def open_adj_entries_jobs
    []
  end
end