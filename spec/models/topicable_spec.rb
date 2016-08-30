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

require 'rails_helper'

RSpec.describe Topicable, type: :model do
  let!(:topics_list_1) { { "topics_list"    => ["topic1", "topic2", "Topic2"],
                           "topicable_type" => "Dataset",
                           "topicable_id"   => "c547146d-de0c-47ff-a406-5125667fd533"} }

  let!(:topics_list_2) { { "topics_list"    => ["topic1", "topic2", "Topic3"],
                           "topicable_type" => "Dataset",
                           "topicable_id"   => "c547146d-de0c-47ff-a406-5125667fd534"} }

  let(:topics_list_3)  { { "topics_list"    => ["topic1", "topic2"],
                           "topicable_type" => "Dataset",
                           "topicable_id"   => "c547146d-de0c-47ff-a406-5125667fd534"} }

  let!(:topicables) {
    Topic.find_or_create_by_name(topics_list_1)
    Topic.find_or_create_by_name(topics_list_2)
    topicables = Topicable.all
  }

  let!(:topics) {
    topics = Topic.all
  }

  let!(:topicable_first)  { topicables[0] }
  let!(:topicable_second) { topicables[1] }
  let!(:topicable_third)  { topicables[2] }
  # Recent list
  let!(:topic_first)      { topics[2]     }
  let!(:topic_second)     { topics[1]     }
  let!(:topic_third)      { topics[0]     }

  it 'Is valid' do
    expect(topicable_first).to                be_valid
    expect(topicable_first.topicable_type).to eq('Dataset')
  end

  it 'Save counter cache' do
    expect(topics.length).to                be(3)
    expect(topic_third.topicables_count).to eq(2)
    expect(topic_first.topicables_count).to eq(1)
  end

  it 'Delete unused topics' do
    expect(Topic.count).to be(3)
    Topic.find_or_create_by_name(topics_list_3)
    expect(Topic.count).to be(2)
  end
end
