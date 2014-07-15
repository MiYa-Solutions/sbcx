# == Schema Information
#
# Table name: accounting_entries
#
#  id                :integer          not null, primary key
#  status            :integer
#  event_id          :integer
#  amount_cents      :integer          default(0), not null
#  amount_currency   :string(255)      default("USD"), not null
#  ticket_id         :integer
#  account_id        :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  type              :string(255)
#  description       :string(255)
#  balance_cents     :integer          default(0), not null
#  balance_currency  :string(255)      default("USD"), not null
#  agreement_id      :integer
#  external_ref      :string(255)
#  collector_id      :integer
#  collector_type    :string(255)
#  matching_entry_id :integer
#

class AdjustmentEntry < AccountingEntry
  before_save :convert_ticket_ref_id
  validate :check_ticket_ref_id
  validates_numericality_of :ticket_ref_id
  attr_writer :ticket_ref_id

  has_many :notifications, as: :notifiable

  def ticket_ref_id
    @ticket_ref_id || ticket.try(:ref_id)
  end

  def amount_direction
    1
  end

  ##
  # state_machine statuses
  ##

  STATUS_ACCEPTED  = 8001
  STATUS_REJECTED  = 8002
  STATUS_CANCELED  = 8003
  STATUS_SUBMITTED = 8004


  state_machine :status do
    state :canceled, value: STATUS_CANCELED
    state :cleared, value: STATUS_CLEARED # reserved only when the affiliate is not a member
    state :rejected, value: STATUS_REJECTED
    state :accepted, value: STATUS_ACCEPTED
    state :submitted, value: STATUS_SUBMITTED


    event :cancel do
      transition :rejected => :canceled
    end
  end


  private
  def the_ticket
    @the_ticket ||= find_the_ticket
  end

  def find_the_ticket
    Ticket.where("organization_id = ? AND ref_id = ?", account.organization.id, ticket_ref_id).first if ticket_ref_id.to_i > 0
  end

  def convert_ticket_ref_id
    self.ticket = the_ticket
  end

  def check_ticket_ref_id
    #errors.add :ticket_ref_id, "Invalid ticket reference" if the_ticket.nil?
    errors.add :ticket_ref_id, "Invalid ticket reference" unless ticket_belongs_to_org?
  end

  def ticket_belongs_to_org?
    the_ticket && the_ticket.organization == account.organization
  end

end
