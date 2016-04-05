class AddAttrToPostingRules < ActiveRecord::Migration
  def change
    add_column :posting_rules, :time_bound, :boolean, :default => false
    add_column :posting_rules, :sunday, :boolean, :default => false
    add_column :posting_rules, :monday, :boolean, :default => false
    add_column :posting_rules, :tuesday, :boolean, :default => false
    add_column :posting_rules, :wednesday, :boolean, :default => false
    add_column :posting_rules, :thursday, :boolean, :default => false
    add_column :posting_rules, :friday, :boolean, :default => false
    add_column :posting_rules, :saturday, :boolean, :default => false

    add_column :posting_rules, :sunday_from, :time
    add_column :posting_rules, :monday_from, :time
    add_column :posting_rules, :tuesday_from, :time
    add_column :posting_rules, :wednesday_from, :time
    add_column :posting_rules, :thursday_from, :time
    add_column :posting_rules, :friday_from, :time
    add_column :posting_rules, :saturday_from, :time

    add_column :posting_rules, :sunday_to, :time
    add_column :posting_rules, :monday_to, :time
    add_column :posting_rules, :tuesday_to, :time
    add_column :posting_rules, :wednesday_to, :time
    add_column :posting_rules, :thursday_to, :time
    add_column :posting_rules, :friday_to, :time
    add_column :posting_rules, :saturday_to, :time

  end
end
