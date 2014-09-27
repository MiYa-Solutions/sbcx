class RemoveInvalidJobEmails < ActiveRecord::Migration
  def up
    Ticket.all.map do  |j|
      if j.email.present? && ValidatesEmailFormatOf.validate_email_format(j.email)
        j.email = nil
        j.save!
      end
    end
  end
end
