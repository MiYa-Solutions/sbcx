class EntryCollection
  include Enumerable

  delegate :all, to: :entries

  def initialize(entries)
    @entries = entries
  end

  def each
    @entries.each do |e|
      yield e
    end
  end

  # created a none used argument to mimic the api of ActiveRecord::Relation
  def sum(column = :amount_cents)
    res = 0
    @entries.each do |e|
      res += e.amount_cents.abs
    end
    res
  end

  private
  def entries
    @entries
  end

end