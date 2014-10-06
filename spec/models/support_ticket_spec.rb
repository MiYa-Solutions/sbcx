require 'spec_helper'

describe SupportTicket do
  subject { SupportTicket.new }

  it { should respond_to :subject }
  it { should respond_to :description }
  it { should belong_to :organization }
  it { should belong_to :user }

  it {should validate_presence_of :subject}
  it {should validate_presence_of :description}
end
