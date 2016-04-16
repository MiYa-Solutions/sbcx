class IndexPostingRulesProps < ActiveRecord::Migration
  def up
    execute "CREATE INDEX posting_rule_properties ON posting_rules USING GIN(properties)"
  end

  def down
    execute "DROP INDEX posting_rule_properties"
  end
end
