# == Schema Information
#
# Table name: appointments
#
#  id               :integer          not null, primary key
#  starts_at        :datetime
#  ends_at          :datetime
#  title            :string(255)
#  description      :text
#  all_day          :boolean
#  recurring        :boolean
#  appointable_id   :integer
#  appointable_type :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  creator_id       :integer
#  updater_id       :integer
#  organization_id  :integer
#

class Appointment < ActiveRecord::Base
  belongs_to :appointable, :polymorphic => true
  belongs_to :organization
  stampable

  validates_presence_of :title, :appointable, :organization

  validate :check_starts_at_text
  validate :check_ends_at_text
  validate :start_before_end

  scope :before, ->(end_time) { { :conditions => ["ends_at < ?", Appointment.format_date(end_time)] } }
  scope :after, ->(start_time) { { :conditions => ["starts_at > ?", Appointment.format_date(start_time)] } }
  scope :my_appointments, ->(org_id, start_time, end_time) { where("organization_id = ?", org_id).before(end_time).after(start_time) }

  # virtual attributes
  attr_writer :starts_at_date_text, :starts_at_time_text, :ends_at_date_text, :ends_at_time_text

  # transform the dates before saving
  before_validation :save_starts_at_text
  before_validation :save_ends_at_text

  def starts_at_date_text
    @starts_at_date_text || (I18n.localize(Time.zone.parse(starts_at.to_s), format: :date_only) if starts_at.present?)
  end

  def starts_at_time_text
    @starts_at_time_text || (I18n.localize(starts_at.to_time.in_time_zone(Time.zone), format: :time_only) if starts_at.present?)
  end

  def ends_at_date_text
    @ends_at_date_text || (I18n.localize(Time.zone.parse(ends_at.to_s), format: :date_only) if ends_at.present?)
  end

  def ends_at_time_text
    @ends_at_time_text || (I18n.localize(ends_at.to_time.in_time_zone(Time.zone), format: :time_only) if ends_at.present?)
  end


  def as_json(options = {})
    {
        :id               => self.id,
        :title            => self.title,
        :description      => self.description || "",
        :start            => starts_at,
        :end              => ends_at,
        :allDay           => all_day,
        :recurring        => recurring,
        #:eurl => Rails.application.routes.url_helpers.appointment_path(id),
        :appointable_id   => appointable_id,
        :appointable_type => appointable_type

    }

  end


  def self.format_date(date_time)
    Time.zone.at(date_time.to_i).to_formatted_s(:db)
  end

  private

  def check_ends_at_text
    errors.add :ends_at_date_text, "cannot be blank" unless @ends_at_date_text.present? || ends_at.present? || all_day
    errors.add :ends_at_date_text, "cannot be parsed" if @ends_at_date_text.present? && Time.zone.parse(@ends_at_date_text).nil?
  rescue ArgumentError
    errors.add :ends_at_date_text, "is out of range"
  end

  def check_starts_at_text
    errors.add :starts_at_date_text, "Can't be blank" unless @starts_at_date_text.present? || starts_at.present?
    errors.add :starts_at_date_text, "cannot be parsed" if @starts_at_date_text.present? && Time.zone.parse(@starts_at_date_text).nil?
  rescue ArgumentError
    errors.add :starts_at_date_text, "is out of range"
  end

  def start_before_end
    errors.add(:ends_at_date_text, "End time can't be before start time") if ends_at && ends_at < starts_at || ends_at == starts_at && !all_day
  end

  def save_starts_at_text
    self.starts_at = Time.zone.parse("#{@starts_at_date_text} #{@starts_at_time_text}") if @starts_at_date_text.present?
  end

  def save_ends_at_text
    if @ends_at_date_text.present?
      self.ends_at = Time.zone.parse("#{@ends_at_date_text} #{@ends_at_time_text}")
    else
      self.ends_at = Time.zone.parse("#{@starts_at_date_text} #{@starts_at_time_text}") if @starts_at_date_text.present? && all_day
    end

  end
end

