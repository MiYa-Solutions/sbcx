class SubcontractingAgreementObserver < ActiveRecord::Observer
  def after_create(record)
    Rails.logger.debug { "invoked SubcontractingAgreementObserver after create" }
    event         = AgrNewSubconEvent.new
    event.user    = record.creator
    event.creator = record.creator
    record.events << event
  end

  def after_submit_for_approval(agreement, transition)
    change_reason = agreement.change_reason ? agreement.change_reason : ""
    other_party   = agreement.updater.organization == agreement.organization ? agreement.organization : agreement.counterparty

    description_with_reason = I18n.t('events.agreement.submitted.description', originator: agreement.creator.organization.name, counterparty: other_party.name) +
        ": " + change_reason

    agreement.events << AgrSubmittedEvent.new(description: description_with_reason)
    Rails.logger.debug { "invoked observer after_submit_for_approval \n #{agreement.inspect} \n #{transition.inspect}" }
  end

end