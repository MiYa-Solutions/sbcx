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


end
