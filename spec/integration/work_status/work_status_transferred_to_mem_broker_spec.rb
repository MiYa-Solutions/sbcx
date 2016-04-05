require 'spec_helper'

describe 'Work Status Transferred to mem broker' do

  include_context 'brokered job'

  context 'when subcon has multiple users' do
    before do
      subcon_job.save
      subcon.users << FactoryGirl.build(:my_technician)
      with_user(subcon_admin) do
        accept_the_job subcon_job
        dispatch_the_job subcon_job, subcon.users.last
      end
    end

    it 'subcon job should have only two notifications associated' do
      expect(subcon_job.notifications.map { |n| n.class.name }.sort).to eq [ScDispatchNotification.name, ScReceivedNotification.name]
      expect(subcon_job.notifications.where(type: ScDispatchNotification.name).first.user).to eq subcon.users.last
    end

    it 'broker job should have only two notifications associated' do
      expect(broker_job.notifications.map { |n| n.class.name }.sort).to eq [ScAcceptedNotification.name, ScReceivedNotification.name, ScStartedNotification.name]
    end

    it 'prov job should have only two notifications associated' do
      expect(job.notifications.size).to eq org.users.size * 2
      expect(job.notifications.map { |n| n.class.name }.uniq.sort).to eq [ScAcceptedNotification.name, ScStartedNotification.name]
    end

  end

end