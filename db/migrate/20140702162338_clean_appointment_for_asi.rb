class CleanAppointmentForAsi < ActiveRecord::Migration
  def up
    Appointment.all.each do |a|
      a.destroy if a.appointable.nil?
    end
  end

  def down
  end
end
