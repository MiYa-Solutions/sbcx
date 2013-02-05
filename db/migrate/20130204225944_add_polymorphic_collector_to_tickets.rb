class AddPolymorphicCollectorToTickets < ActiveRecord::Migration
  def self.up
    change_table :tickets do |t|
      t.references :collector, :polymorphic => true
    end
  end

  def self.down
    change_table :tickets do |t|
      t.remove_references :collector, :polymorphic => true
    end
  end
end
