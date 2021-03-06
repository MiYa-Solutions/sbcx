# == Schema Information
#
# Table name: materials
#
#  id              :integer          not null, primary key
#  organization_id :integer
#  supplier_id     :integer
#  name            :string(255)
#  description     :text
#  creator_id      :integer
#  updater_id      :integer
#  status          :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  cost_cents      :integer          default(0), not null
#  cost_currency   :string(255)      default("USD"), not null
#  price_cents     :integer          default(0), not null
#  price_currency  :string(255)      default("USD"), not null
#  deleted_at      :datetime
#

class Material < ActiveRecord::Base
  stampable
  acts_as_paranoid
  belongs_to :organization
  belongs_to :supplier
  has_many :boms

  validates_presence_of :supplier, :organization, :status, :name, allow_blank: false

  monetize :cost_cents
  monetize :price_cents

  scope :my_materials, ->(org_id) { where("organization_id = ?", org_id) }

  scope :search, ->(org_id, query) { my_materials(org_id).where(arel_table[:name].matches("%#{query}%")).order('id desc') }


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

  def name_web
    res = "[#{id}] #{name}"
    res = res + " (#{description.first(7)})" if description
    res
  end

end
