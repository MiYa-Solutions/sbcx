class SupportComment < Comment
  belongs_to :support_ticket, foreign_key: :commentable_id
end