class AddSubconFeeMoney < ActiveRecord::Migration
  def change
    add_money :tickets, :subcon_fee
  end

end
