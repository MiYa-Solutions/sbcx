class SetRefId < ActiveRecord::Migration
  def up
    MyServiceCall.where(ref_id: nil).all.each do |job|
      job.ref_id = job.id
      job.save!
    end
  end

  def down
  end
end
