module BomsAssociation
  extend ActiveSupport::Concern
  included do
    has_many :boms, dependent: :destroy, inverse_of: :ticket do
      def build(params)
        unless params[:buyer_id].nil? || params[:buyer_id].empty?
          buyer = params[:buyer_type].classify.constantize.find(params[:buyer_id])
        end
        params.delete(:buyer_id)
        params.delete(:buyer_type)

        bom        = Bom.new(params)
        bom.buyer  = buyer
        bom.ticket = proxy_association.owner
        bom
      end
    end

    attr_accessor :to_be_destroyed
    before_destroy :mark_as_destroyed, prepend: true
  end

  private

  def mark_as_destroyed
    # self.to_be_destroyed = true
    update_attribute(:to_be_destroyed, true)
  end

end