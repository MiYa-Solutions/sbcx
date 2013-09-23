# == Schema Information
#
# Table name: tags
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  organization_id :integer
#

class Tag < ActiveRecord::Base

  ### ASSOCIATIONS:

  belongs_to :organization
  has_many :taggings
  has_many :taggables, through: :taggings

  ### VALIDATIONS:
  validates_presence_of :organization_id
  validates_uniqueness_of :name, scope: :organization_id
end
