# == Schema Information
#
# Table name: boms
#
#  id             :integer          not null, primary key
#  ticket_id      :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  quantity       :decimal(, )
#  material_id    :integer
#  cost_cents     :integer          default(0), not null
#  cost_currency  :string(255)      default("USD"), not null
#  price_cents    :integer          default(0), not null
#  price_currency :string(255)      default("USD"), not null
#  buyer_id       :integer
#  buyer_type     :string(255)
#  creator_id     :integer
#  updater_id     :integer
#

class Bom < ActiveRecord::Base
  belongs_to :ticket, inverse_of: :boms
  belongs_to_with_deleted :material, with_deleted: true
  belongs_to :buyer, :polymorphic => true
  belongs_to :provider_bom, class_name: 'Bom'
  belongs_to :subcon_bom, class_name: 'Bom'
  has_many :invoice_items, as: :invoiceable
  has_many :invoices, through: :invoice_items

  stampable
  monetize :cost_cents, :numericality => { :greater_than => 0 }
  monetize :price_cents, :numericality => { :greater_than => 0 }

  validates_presence_of :ticket, :cost_cents, :price_cents, :quantity, :material_id
  validates_numericality_of :quantity
  validate :validate_buyer
  validate :check_ticket_status


  before_validation :set_material
  before_validation :set_default_buyer
  after_save :synch_with_affiliates

  # virtual attributes
  attr_accessor :material_name


  def total_cost
    self.cost * self.quantity unless self.cost.nil?
  end

  def total_price
    self.price * self.quantity unless self.quantity.nil?
  end

  alias_method :amount, :total_price

  def description
    attribute(:description) || live_or_deleted_material.try(:description)
  end


  def set_material

    unless !self.material.nil? || @material_name.nil?
      existing_material = Material.find_by_organization_id_and_name(self.ticket.organization.id, @material_name)
      if existing_material.nil?
        existing_material = Material.create(organization: self.ticket.organization, name: @material_name, price: self.price, cost: self.cost, supplier: self.ticket.organization.becomes(Supplier), description: description)
      end
      self.material = existing_material
    end

  end

  def material_name
    live_or_deleted_material ? live_or_deleted_material.name : ''
  end

  def live_or_deleted_material
    @live_or_deleted_material ||= (material || Material.with_deleted.where(id: material_id).first)
  end

  def name
    material_name
  end

  def validate_buyer

    unless ticket.nil? || ticket.invalid? # if there is no ticket associated this bom is invalid anyway
      valid_values = [ticket.provider_id,
                      ticket.subcontractor_id,
                      ticket.organization_id,
      ].compact + ticket.organization.user_ids

      errors.add(:buyer_id, I18n.t('activerecord.errors.models.bom.buyer')) unless valid_values.include? buyer_id
    end

  end

  def set_default_buyer
    if self.buyer_id.nil?
      self.buyer_id   = self.ticket.try(:organization_id)
      self.buyer_type = "Organization"
    end
  end

  def check_ticket_status
    unless ticket.nil?
      errors.add :ticket, "Can't add/update a bom for a completed job " if ticket.work_done? && (self.changed? || self.new_record?)
      errors.add :ticket, "Can't add/update a bom before accepting the job " if ticket.kind_of?(TransferredServiceCall) && !(ticket.accepted? || ticket.transferred?) && self.creator
    end
  end

  def destroy
    unless ticket.can_change_boms? || ticket.to_be_destroyed
      self.errors.add :ticket, "Can't delete a bom for a completed ticket"
      raise ActiveRecord::RecordInvalid.new(self)
    end
    super
    provider_bom.destroy if provider_bom
    subcon_bom.destroy if subcon_bom
  end

  # determines if the bom was paid by the org that owns the ticket
  # the method addresses the use case where a User was the buyer of the part
  # in case the org that owns the ticket is a broker, then it is considered "mine" (will return true) if the subcontractor is the buyer
  # using the options by specifying really_mine then then subcon bom will not be considered mine for a broker ticket
  def mine?(options = {})
    really_mine = options[:really_mine] ? options[:really_mine] : false
    case buyer
      when Organization
        if really_mine
          self.buyer == self.ticket.organization
        else
          self.buyer == self.ticket.organization || (self.ticket.my_role == :broker && self.buyer == self.ticket.subcontractor.becomes(Organization))
        end
      when User
        User.where(organization_id: ticket.organization.id).pluck(:id).include?(buyer.id)
      else
        raise "Unexpected buyer type (not user nor Organization): #{buyer.class}"
    end
  end

  private

  def synch_with_affiliates
    BomSynchService.new(self).synch
  end
end

