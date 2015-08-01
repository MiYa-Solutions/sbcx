module Statementable
  extend ActiveSupport::Concern

  included do
    has_many :statements
  end

  def statement_entries
    open_job_entries + open_adj_entries
  end

end