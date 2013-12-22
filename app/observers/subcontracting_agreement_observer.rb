class SubcontractingAgreementObserver < ActiveRecord::Observer
  observe OrganizationAgreement

  def after_create(record)
    Rails.logger.debug { "invoked SubcontractingAgreementObserver after create" }
    event         = AgrNewSubconEvent.new
    event.user    = record.creator
    event.creator = record.creator
    record.events << event
    Rails.logger.debug { "invoked SubcontractingAgreementObserver after create end" }
  end

  def after_submit_change(agreement, transition)
    agreement.events << AgrChangeSubmittedEvent.new
  end

  def after_submit_for_approval(agreement, transition)

    agreement.events << AgrSubmittedEvent.new
    Rails.logger.debug { "invoked observer after_submit_for_approval \n #{agreement.inspect} \n #{transition.inspect}" }
  end

  def after_accept(agreement, transition)
    Rails.logger.debug { "invoked observer after_accept \n #{agreement.inspect} \n #{transition.inspect}" }

    agreement.events << AgrSubconAcceptedEvent.new
  end

  private

  def description_with_reason(agreement)
    change_reason = agreement.change_reason ? agreement.change_reason : ""
    other_party   = agreement.updater.organization == agreement.organization ? agreement.organization : agreement.counterparty

    description_with_reason = I18n.t('events.agreement.submitted.description', originator: agreement.creator.organization.name, counterparty: other_party.name) +
        ": " + change_reason

  end

end