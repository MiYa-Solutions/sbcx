class AddPropsToPostingRules < ActiveRecord::Migration
  def change
    add_column :posting_rules, :properties, :hstore
  end
end
