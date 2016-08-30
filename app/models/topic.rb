# == Schema Information
#
# Table name: topics
#
#  id               :uuid             not null, primary key
#  name             :string
#  topicables_count :integer          default(0)
#  created_at       :datetime
#

class Topic < ApplicationRecord
  has_many :topicables, dependent: :destroy

  validates_presence_of   :name
  validates_uniqueness_of :name, if: :validates_name_uniqueness?

  scope :recent,         -> { order('created_at DESC') }
  scope :filter_by_type, -> (type) { joins(:topicables).where(topicables: { topicable_type: type.classify }) }

  class << self
    def find_by_id_or_name(param)
      topic_id = where(name: param).or(where(id: param)).pluck(:id).min
      find(topic_id) rescue nil
    end

    def fetch_all(options)
      by_type = options['id'] if options['id'].present?

      topics = recent
      topics = topics.filter_by_type(by_type.classify).distinct if by_type.present?
      topics
    end

    def find_or_create_by_name(list)
      topics_list    = list['topics_list']
      topicable_id   = list['topicable_id']
      topicable_type = list['topicable_type']
      topicable_slug = list['topicable_slug'] if list['topicable_slug'].present?

      return [] if topics_list.empty? || topicable_id.blank? || topicable_type.blank?

      clear_topics(topicable_id, topicable_type)
      create_topics(topics_list, topicable_id, topicable_type, topicable_slug)
    end

    def clear_topics(topicable_id, topicable_type)
      Topicable.where(topicable_id: topicable_id, topicable_type: topicable_type).each do |topic|
        topic.destroy
      end
    end

    def create_topics(topics_list, topicable_id, topicable_type, topicable_slug)
      topics_list.map do |topic_name|
        current_topic = find_or_create_by(name: topic_name.downcase)
        Topicable.create(topic_id: current_topic.id, topicable_id: topicable_id, topicable_type: topicable_type, topicable_slug: topicable_slug)
      end
    end
  end

  def topicables_by_type
    types = topicables.pluck(:topicable_type)

    types.uniq.map do |topicable|
      base_path      = "#{ENV['API_GATEWAY_URL']}/#{topicable.downcase.parameterize.pluralize}"
      topicable_info = topicables.filter_by_type(topicable.classify).map do |topicable|
                       { id:         topicable.topicable_id,
                         slug:       topicable.topicable_slug,
                         type:       topicable.topicable_type,
                         uri:        "#{base_path}/#{topicable.topicable_id}",
                         created_at: topicable.created_at }
                     end

      { :"#{topicable.downcase.parameterize.pluralize}" => topicable_info }
    end
  end

  def validates_name_uniqueness?
    true
  end
end
