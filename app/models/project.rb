class Project < ActiveRecord::Base
  include InvoiceableProject

  belongs_to :organization
  belongs_to :contractor, class_name: 'Affiliate'
  belongs_to :subcontractor, class_name: 'Affiliate'
  belongs_to :customer
  has_many :tickets
  has_many :events, as: :eventable

  validates_uniqueness_of :name, scope: :organization_id

  def contractors
    tickets.collect(&:provider)
  end

  def subcontractors
    tickets.collect(&:subcontractor)
  end

  def customers
    tickets.collect(&:customer)
  end

  STATUS_NEW         = 0
  STATUS_IN_PROGRESS = 1
  STATUS_ON_HOLD     = 2
  STATUS_COMPLETED   = 3
  STATUS_CLOSED      = 4
  STATUS_CANCELED      = 5

  state_machine :status, initial: :new do
    state :new, value: STATUS_NEW
    state :in_progress, value: STATUS_IN_PROGRESS
    state :on_hold, value: STATUS_ON_HOLD
    state :completed, value: STATUS_COMPLETED
    state :closed, value: STATUS_CLOSED
    state :canceled, value: STATUS_CANCELED
  end

  def work_done?
    completed? || closed? || canceled?
  end

  def customer_name
    customer ? customer.name : ''
  end


end
