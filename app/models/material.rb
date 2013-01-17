# == Schema Information
#
# Table name: materials
#
#  id              :integer         not null, primary key
#  organization_id :integer
#  supplier_id     :integer
#  name            :string(255)
#  description     :text
#  cost            :decimal(, )
#  price           :decimal(, )
#  creator_id      :integer
#  updater_id      :integer
#  status          :integer
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#

class Material < ActiveRecord::Base
  stampable
  belongs_to :organization
  belongs_to :supplier
  has_many :boms

  validates_presence_of :supplier, :organization, :status, :name, :price, :cost, allow_blank: false
  validates_uniqueness_of :name, scope: [:organization_id, :supplier_id]

  monetize :cost_cents
  monetize :price_cents

  before_validation :create_supplier, if: "supplier == nil"

  scope :my_materials, ->(org_id) { where("organization_id = ?", org_id) }

  scope :search, ->(org_id, query) { my_materials(org_id).where(arel_table[:name].matches("%#{query}%")).order('name') }


  # virtual attributes
  attr_accessor :supplier_name

  STATUS_AVAILABLE    = 0
  STATUS_OUT_OF_STOCK = 1
  STATUS_DISABLED     = 1


  state_machine :status, initial: :available do
    state :available, value: STATUS_AVAILABLE
    state :out_of_stock, value: STATUS_OUT_OF_STOCK
    state :disabled, value: STATUS_DISABLED

    event :run_out do
      transition :available => :out_of_stock
    end

    event :disable do
      transition [:available, :out_of_stock] => :disabled
    end

    event :enable do
      transition :disabled => :available
    end

    event :back_in_stock do
      transition :out_of_stock => :available
    end
  end

  def create_supplier
    unless @supplier_name.nil?
      role          = OrganizationRole.find(OrganizationRole::SUPPLIER_ROLE_ID)
      self.supplier = Supplier.new(name: @supplier_name, organiztion_roles: [role])
      self.organization.suppliers << self.supplier

    end

  end

end
