require 'spec_helper'

describe AgrChangeRejectedEvent do

  let(:agr) { FactoryGirl.build(:subcontracting_agreement) }
  let(:event) { AgrChangeRejectedEvent.new(eventable: agr, change_reason: 'test reason') }

  it 'should have a change_reason attribute' do
    expect(event).to respond_to(:change_reason)
  end

  context 'when created' do

    before do
      agr.status = OrganizationAgreement::STATUS_PENDING_ORG_APPROVAL
      event.save! unless example.metadata[:skip_creation]
    end

    it 'should trigger the rejection notification', skip_creation: true do
      notification = stub_model(AgrChangeRejectedNotification, deliver: true, notifiable: agr)
      AgrChangeRejectedNotification.stub(:new => notification)
      AgrChangeRejectedNotification.should_receive(:new)
      event.save!
    end

  end


  context 'init attributes' do

    before do
      event.valid?
    end

    it 'the event should be valid' do
      expect(event).to be_valid
    end

    it 'should have a reference id of 200005' do
      expect(event.reference_id).to be 200005
    end

    it 'should have a description taken from I18n' do
      expect(event.description).to eq I18n.t('agr_change_rejected_event.description', other_party: agr.counterparty.name)
    end

    it 'should have a name taken from I18n' do
      expect(event.name).to eq I18n.t('agr_change_rejected_event.name')
    end
  end
end