class AgrNewSubconEvent < AgreementEvent
  def init
    self.name = I18n.t('events.agreement.new_subcon_agreement.name')
    self.description = default_description if self.description.nil?
    self.reference_id = 200001
  end

  def notification_recipients
    ##  if agreement creator is the organization notify c.party else notify organization
    #if creator.organization == agreement.organization
    #  User.my_admins(agreement.counterparty.id)
    #else
    #  User.my_admins(agreement.organization.id)
    #end
    nil
  end

  def notification_class
    nil
  end

  private

  def default_description
    the_creator = agreement.creator.organization.name + "(" + agreement.creator.name + ")"
    the_role    = other_party == agreement.organization ? SubcontractingAgreement.human_attribute_name(:organization) : SubcontractingAgreement.human_attribute_name(:counterparty)
    I18n.t('events.agreement.new_subcon_agreement.description', creator: the_creator, counterparty: other_party.name, role: the_role)
  end


end