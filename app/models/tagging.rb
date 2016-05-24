# == Schema Information
#
# Table name: taggings
#
#  id            :uuid             not null, primary key
#  tag_id        :uuid
#  taggable_id   :uuid
#  taggable_type :string
#  taggable_slug :string
#  created_at    :datetime
#

class Tagging < ApplicationRecord
  belongs_to :tag, counter_cache: true

  validates_presence_of   :tag_id
  validates_uniqueness_of :tag_id, scope: [:taggable_type, :taggable_id]

  after_destroy :remove_unused_tags

  scope :filter_by_type, -> (type) { where(taggable_type: type.classify) }

  class << self
    def find_by_id_or_slug(param)
      tagging_id = where(taggable_slug: param).or(where(taggable_id: param)).pluck(:taggable_id).min
      find_by(taggable_id: tagging_id) rescue nil
    end

    def tags_by_taggable(taggable_id)
      taggings = where(taggable_id: taggable_id)
      taggings = taggings.map { |t| t.tag.name }.uniq
      taggings
    end
  end

  private

    def remove_unused_tags
      tag.destroy if tag.reload.taggings_count.zero?
    end
end
