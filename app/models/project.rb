class Project < ActiveRecord::Base
  belongs_to :organization
  has_many :tickets
  validates_uniqueness_of :name
end
