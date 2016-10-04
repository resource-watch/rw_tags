# frozen_string_literal: true
# == Schema Information
#
# Table name: taggings or topicable
#
#  id             :uuid    not null, primary key
#
### for taggings
#  tag_id         :uuid
#  taggable_id    :uuid
#  taggable_type  :string
#  taggable_slug  :string
#
### for topicables
#  topic_id       :uuid
#  topicable_id   :uuid
#  topicable_type :string
#  topicable_slug :string
###
#  created_at     :datetime
#

class TaggingTopicableSerializer < ApplicationSerializer
  attributes :id, :slug, :type, :tags, :topics

  def id
    object.try(:taggable_id) || object.try(:topicable_id)
  end

  def slug
    object.try(:taggable_slug) || object.try(:topicable_slug)
  end

  def type
    object.try(:taggable_type) || object.try(:topicable_type)
  end

  def tags
    Tagging.tags_by_taggable(id)
  end

  def topics
    Topicable.topics_by_topicable(id)
  end
end
