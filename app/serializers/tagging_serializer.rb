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

class TaggingSerializer < ApplicationSerializer
  attributes :id, :slug, :type, :tags

  def id
    object.try(:taggable_id)
  end

  def slug
    object.try(:taggable_slug)
  end

  def type
    object.try(:taggable_type)
  end

  def tags
    Tagging.tags_by_taggable(id)
  end
end
