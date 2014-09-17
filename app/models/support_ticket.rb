class SupportTicket < ActiveRecord::Base
  stampable
  belongs_to :organization
  belongs_to :user, foreign_key: :creator_id

  validates_presence_of :organization, :subject, :description
end
