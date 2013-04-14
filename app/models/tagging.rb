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