class AgrActivatedSubconNotification < AgreementNotification
  def html_message
    # html_message: '%{creator} has created %{link} with %{counterparty} as the %{role}'
    I18n.t('notifications.agreement.new_subcon_agreement.html_message',
           creator:      agreement.creator.organization.name,
           link:         agreement_link,
           counterparty: other_party.name,
           role:         other_party_role).html_safe
  end

  def default_subject
    # subject: '%{creator} has created a new Subcontracting Agreement with you as the %{role}'

    I18n.t('notifications.agreement.new_subcon_agreement.subject',
           creator: agreement.creator.organization.name,
           role:    other_party_role)
  end

  def default_content
    # content: 'Please go to the agreement, to review and accept it in order to be able to transfer jobs between one another.'

    I18n.t('notifications.agreement.new_subcon_agreement.content')
  end

  def other_party
    if agreement.updater.organization == agreement.organization
      agreement.counterparty
    else
      agreement.organization
    end
  end

  def other_party_role
    if agreement.creator.organization == agreement.organization
      SubcontractingAgreement.human_attribute_name(:counterparty)
    else
      SubcontractingAgreement.human_attribute_name(:organization)
    end

  end

end