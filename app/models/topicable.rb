# frozen_string_literal: true
# == Schema Information
#
# Table name: topicables
#
#  id             :uuid             not null, primary key
#  topic_id       :uuid
#  topicable_id   :uuid
#  topicable_type :string
#  topicable_slug :string
#  created_at     :datetime
#

class Topicable < ApplicationRecord
  belongs_to :topic, counter_cache: true

  validates_presence_of   :topic_id
  validates_uniqueness_of :topic_id, scope: [:topicable_type, :topicable_id]

  after_destroy :remove_unused_topics

  scope :filter_by_type, -> (type) { where(topicable_type: type.classify) }

  class << self
    def find_by_id_or_slug(param)
      topicable_id = where(topicable_slug: param).or(where(topicable_id: param)).pluck(:topicable_id).min
      find_by(topicable_id: topicable_id) rescue nil
    end

    def topics_by_topicable(topicable_id)
      topicables = includes(:topic).where(topicable_id: topicable_id)
      topicables = topicables.map { |t| t.topic.name }.uniq
      topicables
    end
  end

  private

    def remove_unused_topics
      topic.destroy if topic.reload.topicables_count.zero?
    end
end
