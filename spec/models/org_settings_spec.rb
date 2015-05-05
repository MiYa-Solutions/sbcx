require 'spec_helper'

describe OrgSettings do
  let(:org) { FactoryGirl.build(:member_org) }
  let(:org_settings) { org.settings }

  it 'should respond to save' do
    expect(org_settings).to respond_to :save
  end

  it 'should respond to persisted?' do
    expect(org_settings).to respond_to 'persisted?'
  end

  it 'should respond to default_tax' do
    expect(org_settings).to respond_to :default_tax
  end

  it 'should respond to default_tax=' do
    expect(org_settings).to respond_to 'default_tax='
  end

  it 'should respond to validate_job_ext_ref' do
    expect(org_settings).to respond_to :validate_job_ext_ref
  end

  it 'should respond to external_ref_unique' do
    expect(org_settings).to respond_to :external_ref_unique
  end

  it 'should respond to validate_job_ext_ref=' do
    expect(org_settings).to respond_to 'validate_job_ext_ref='
  end

  it 'should validate numericality of default tax' do
    expect(org_settings).to validate_numericality_of(:default_tax)
  end

  it 'translation is working' do
    expect(OrgSettings.human_attribute_name(:default_tax)).to eq I18n.t('activemodel.attributes.org_settings.default_tax')
    expect(OrgSettings.human_attribute_name(:validate_job_ext_ref)).to eq I18n.t('activemodel.attributes.org_settings.validate_job_ext_ref')
    expect(OrgSettings.human_attribute_name(:external_ref_unique)).to eq I18n.t('activemodel.attributes.org_settings.external_ref_unique')
  end


end