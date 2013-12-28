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
    agreement.events << AgrChangeSubmittedEvent.new(change_reason: agreement.change_reason)
  end

  def after_submit_for_approval(agreement, transition)

    agreement.events << AgrSubmittedEvent.new
    Rails.logger.debug { "invoked observer after_submit_for_approval \n #{agreement.inspect} \n #{transition.inspect}" }
  end

  def after_accept(agreement, transition)
    Rails.logger.debug { "invoked observer after_accept \n #{agreement.inspect} \n #{transition.inspect}" }

    agreement.events << AgrSubconAcceptedEvent.new
  end

  def after_reject(agreement, transition)
    agreement.events << AgrChangeRejectedEvent.new(change_reason: agreement.change_reason)
  end

end