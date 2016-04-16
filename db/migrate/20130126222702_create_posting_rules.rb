class CreatePostingRules < ActiveRecord::Migration
  def change
    create_table :posting_rules do |t|
      t.integer :agreement_id
      t.string :type
      t.decimal :rate
      t.string :rate_type

      t.timestamps
    end
  end
end
