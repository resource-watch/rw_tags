# == Schema Information
#
# Table name: topics
#
#  id               :uuid             not null, primary key
#  name             :string
#  topicables_count :integer          default(0)
#  created_at       :datetime
#

class TopicSerializer < ApplicationSerializer
  attributes :id, :name, :topicables_count, :topicable_objects

  def topicable_objects
    object.topicables_by_type
  end
end
