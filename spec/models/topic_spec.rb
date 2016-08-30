# == Schema Information
#
# Table name: topics
#
#  id               :uuid             not null, primary key
#  name             :string
#  topicables_count :integer          default(0)
#  created_at       :datetime
#

require 'rails_helper'

RSpec.describe Topic, type: :model do
  let!(:topics_list) { { "topics_list"    => ["topic1", "topic second", "Topic second", "Topic3"],
                         "topicable_type" => "Dataset",
                         "topicable_id"   => "c547146d-de0c-47ff-a406-5125667fd533"} }

  let!(:topics) {
    Topic.find_or_create_by_name(topics_list)
    topics = Topic.all
  }

  let!(:topic_first)  { topics.find_by(name: 'topic1')       }
  let!(:topic_second) { topics.find_by(name: 'topic second') }
  let!(:topic_third)  { topics.find_by(name: 'topic3')       }

  it 'Is valid' do
    expect(topic_first).to      be_valid
    expect(topic_first.name).to eq('topic1')
  end

  it 'Save topics as downcase and unique' do
    expect(topics.length).to be(3)
  end

  it 'Do not allow to create topic without name' do
    topic_reject = Topic.new(name: '')

    topic_reject.valid?
    expect {topic_reject.save!}.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Name can't be blank")
  end

  it 'Do not allow to create topic with name douplications' do
    expect(topic_first).to be_valid
    topic_reject = Topic.new(name: 'topic1')

    topic_reject.valid?
    expect {topic_reject.save!}.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Name has already been taken")
  end
end
