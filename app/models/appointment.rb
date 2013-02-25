# == Schema Information
#
# Table name: appointments
#
#  id               :integer         not null, primary key
#  starts_at        :datetime
#  ends_at          :datetime
#  title            :string(255)
#  description      :text
#  all_day          :boolean
#  recurring        :boolean
#  appointable_id   :integer
#  appointable_type :string(255)
#  created_at       :datetime        not null
#  updated_at       :datetime        not null
#  creator_id       :integer
#  updater_id       :integer
#  organization_id  :integer
#

class Appointment < ActiveRecord::Base
  belongs_to :appointable, :polymorphic => true
  belongs_to :organization
  validates_presence_of :starts_at, :ends_at, :title, :appointable, :organization
  validate :start_before_end
  stampable

  scope :before, ->(end_time) { {:conditions => ["ends_at < ?", Appointment.format_date(end_time)] }}
  scope :after, ->(start_time) { {:conditions => ["starts_at > ?", Appointment.format_date(start_time)] }}
  scope :my_appointments, ->(org_id, start_time, end_time) { where("organization_id = ?", org_id).before(end_time).after(start_time)}


  def as_json(options = {})
    {
        :id => self.id,
        :title => self.title,
        :description => self.description || "",
        :start => starts_at,
        :end => ends_at,
        :allDay => all_day,
        :recurring => recurring,
        #:eurl => Rails.application.routes.url_helpers.appointment_path(id),
        :appointable_id => appointable_id,
        :appointable_type => appointable_type

    }

  end


  def self.format_date(date_time)
    Time.zone.at(date_time.to_i).to_formatted_s(:db)
  end

  private
  def start_before_end
    errors.add(:ends_at, "Put error text here") if ends_at && ends_at <= starts_at
  end


end
