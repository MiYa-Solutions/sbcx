class ChangeTicketsTransferableDefault < ActiveRecord::Migration
  def up
    change_column_default :tickets, :re_transfer, true
  end

  def down
    change_column_default :tickets, :re_transfer, false
  end
end
