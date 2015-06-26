class CreateStatements < ActiveRecord::Migration
  def change
    create_table :statements do |t|
      t.column :data, :json
      t.userstamps
      t.references :statementable, polymorphic: true
      t.timestamps
    end
  end
end
