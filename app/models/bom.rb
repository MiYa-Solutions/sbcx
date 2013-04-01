# == Schema Information
#
# Table name: boms
#
#  id             :integer         not null, primary key
#  ticket_id      :integer
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#  quantity       :decimal(, )
#  material_id    :integer
#  cost_cents     :integer         default(0), not null
#  cost_currency  :string(255)     default("USD"), not null
#  price_cents    :integer         default(0), not null
#  price_currency :string(255)     default("USD"), not null
#  buyer_id       :integer
#  buyer_type     :string(255)
#

class Bom < ActiveRecord::Base
  belongs_to :ticket
  belongs_to :material
  belongs_to :buyer, :polymorphic => true

  validates_presence_of :ticket, :cost, :price, :quantity, :material_id
  validates_numericality_of :quantity, :cost, :price
  validate :buyer, :validate_buyer

  monetize :cost_cents
  monetize :price_cents

  before_validation :set_material
  before_validation :set_default_cost
  before_validation :set_default_price
  before_validation :set_default_buyer

  # virtual attributes
  attr_accessor :material_name


  def total_cost
    self.cost * self.quantity unless self.cost.nil?
  end

  def total_price
    self.price * self.quantity unless self.quantity.nil?
  end

  def set_default_cost
    if self.cost.nil?
      unless self.material.nil?
        self.cost = self.material.cost
      end
    end

  end

  def set_default_price
    if self.price.nil?
      unless self.material.nil?
        self.price = self.material.price
      end
    end
  end

  def set_material

    unless !self.material.nil? || @material_name.nil?
      existing_material = Material.find_by_organization_id_and_name(self.ticket.organization.id, @material_name)
      if existing_material.nil?
        existing_material = Material.create(organization: self.ticket.organization, name: @material_name, price: self.price, cost: self.cost, supplier: self.ticket.organization.becomes(Supplier))
      end
      self.material = existing_material
    end

  end

  def material_name
    @material_name ||= material.try(:name)
  end

  def validate_buyer

    unless ticket.nil? || ticket.invalid? # if there is no ticket associated this bom is invalid anyway
      valid_values = [ticket.provider_id,
                      ticket.subcontractor_id,
                      ticket.technician_id].compact

      errors.add(:buyer, I18n.t('activerecord.errors.models.bom.buyer')) unless valid_values.include? buyer_id
    end

  end

  def set_default_buyer
    if self.buyer.nil?
      self.buyer = self.ticket.try(:organization)
    end
  end
end

