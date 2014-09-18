class SupportTicket < ActiveRecord::Base
  stampable
  acts_as_commentable
  belongs_to :organization
  belongs_to :user, foreign_key: :creator_id

  validates_presence_of :organization, :subject, :description
end
