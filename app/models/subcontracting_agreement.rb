class SubcontractingAgreement < OrganizationAgreement

  after_initialize :set_cparty_type

  def set_cparty_type
    self.counterparty_type="Organization"
  end


end