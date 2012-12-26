class SubcontractingAgreementObserver < ActiveRecord::Observer
  def after_create(record)
    Rails.logger.debug { "invoked SubcontractingAgreementObserver after create" }
    event      = AgrNewSubconEvent.new
    event.user = record.creator
    record.events << event
  end

  # To change this template use File | Settings | File Templates.
end