class SetTicketTransferableDefault < ActiveRecord::Migration
  def up
    change_column_default :tickets, :transferable, true
  end

  def down
    change_column_default :tickets, :transferable, false
  end
end
