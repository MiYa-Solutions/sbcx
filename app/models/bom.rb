# == Schema Information
#
# Table name: boms
#
#  id         :integer         not null, primary key
#  ticket_id  :integer
#  price      :decimal(, )
#  cost       :decimal(, )
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  quantity   :decimal(, )
#

class Bom < ActiveRecord::Base
  belongs_to :ticket
  belongs_to :material
  validates_presence_of :ticket, :cost, :price, :quantity, :material
  validates_numericality_of :cost, :price, :quantity

  before_validation :set_material
  before_validation :set_default_cost
  before_validation :set_default_price

  # virtual attributes
  attr_accessor :material_name


  def total_cost
    self.cost * self.quantity
  end

  def total_price
    self.price * self.quantity
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
end

