class BomSynchService

  def initialize(bom)
    @bom = bom
  end

  def synch
    if update_provider?
      copy_bom_to_provider
      BomSynchService.new(@provider_bom).synch
    end

    if update_subcon?
      copy_bom_to_subcon
      BomSynchService.new(@subcon_bom).synch
    end
  end

  private

  def update_provider?
    @bom.provider_bom.nil? && @bom.ticket.kind_of?(TransferredServiceCall) &&
        @bom.ticket.provider_id != @bom.ticket.organization_id &&
        @bom.ticket.provider.member?
  end

  def update_subcon?
    @bom.subcon_bom.nil? && @bom.ticket.transferred? &&
        @bom.ticket.subcontractor_id != @bom.ticket.organization_id &&
        @bom.ticket.subcontractor.member?
  end

  def copy_bom_to_provider
    @provider_ticket = @bom.ticket.provider_ticket
    Bom.without_stamps do
      @provider_bom            = @bom.dup
      @provider_bom.ticket_id  = nil
      @provider_bom.creator    = nil
      @provider_bom.updater    = nil
      @provider_bom.buyer      = bom_buyer_for_provider
      @provider_bom.subcon_bom = @bom
      @bom.provider_bom        = @provider_bom
      Bom.transaction do
        @provider_ticket.boms << @provider_bom
        @bom.save!
      end
    end

  end

  def copy_bom_to_subcon
    @subcon_ticket = @bom.ticket.subcon_ticket
    Bom.without_stamps do
      @subcon_bom              = @bom.dup
      @subcon_bom.ticket_id    = nil
      @subcon_bom.creator      = nil
      @subcon_bom.updater      = nil
      @subcon_bom.buyer        = bom_buyer_for_subcon
      @subcon_bom.provider_bom = @bom
      @bom.subcon_bom          = @subcon_bom
      Bom.transaction do
        @subcon_ticket.boms << @subcon_bom
        @bom.save!
      end
    end

  end

  def bom_buyer_for_provider

    # if the material buyer is a user, then set its organization
    if @bom.buyer.instance_of?(User)
      @bom.ticket.organization
    elsif @bom.buyer.becomes(Organization) == @bom.ticket.provider.becomes(Organization)
      @bom.ticket.provider.becomes(Organization)
    else
      @bom.ticket.organization
    end

  end

  def bom_buyer_for_subcon

    # if the material buyer is a user, then set its organization
    if @bom.buyer.instance_of?(User)
      @bom.ticket.organization
    elsif @bom.buyer.becomes(Organization) == @bom.ticket.subcontractor.becomes(Organization)
      @bom.ticket.subcontractor.becomes(Organization)
    else
      @bom.ticket.organization
    end

  end

end