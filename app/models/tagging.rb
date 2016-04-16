# == Schema Information
#
# Table name: taggings
#
#  id            :integer          not null, primary key
#  tag_id        :integer
#  taggable_id   :integer
#  taggable_type :string(255)
#  tagger_id     :integer
#  tagger_type   :string(255)
#  context       :string(128)
#  created_at    :datetime
#

class Tagging < ActiveRecord::Base
  belongs_to :tag
  belongs_to :taggable, :polymorphic => true

  validates_presence_of :tag_id

  after_destroy :remove_unused_tags

  private

  def remove_unused_tags
    if tag.taggings.count.zero?
      tag.destroy
    end
  end

end
