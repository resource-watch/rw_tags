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

require 'rails_helper'

RSpec.describe Tagging, type: :model do
  let!(:tags_list_1) { { "tags_list"     => ["tag1", "tag2", "Tag2"],
                         "taggable_type" => "Dataset",
                         "taggable_id"   => "c547146d-de0c-47ff-a406-5125667fd533"} }

  let!(:tags_list_2) { { "tags_list"     => ["tag1", "tag2", "Tag3"],
                         "taggable_type" => "Dataset",
                         "taggable_id"   => "c547146d-de0c-47ff-a406-5125667fd534"} }

  let(:tags_list_3)  { { "tags_list"     => ["tag1", "tag2"],
                         "taggable_type" => "Dataset",
                         "taggable_id"   => "c547146d-de0c-47ff-a406-5125667fd534"} }

  let!(:taggings) {
    Tag.find_or_create_by_name(tags_list_1)
    Tag.find_or_create_by_name(tags_list_2)
    taggings = Tagging.all
  }

  let!(:tags) {
    tags = Tag.all
  }

  let!(:tagging_first)  { taggings[0] }
  let!(:tagging_second) { taggings[1] }
  let!(:tagging_third)  { taggings[2] }
  # Recent list
  let!(:tag_first)      { tags[2]     }
  let!(:tag_second)     { tags[1]     }
  let!(:tag_third)      { tags[0]     }

  it 'Is valid' do
    expect(tagging_first).to               be_valid
    expect(tagging_first.taggable_type).to eq('Dataset')
  end

  it 'Save counter cache' do
    expect(tags.length).to              be(3)
    expect(tag_third.taggings_count).to eq(2)
    expect(tag_first.taggings_count).to eq(1)
  end

  it 'Delete unused tags' do
    expect(Tag.count).to be(3)
    Tag.find_or_create_by_name(tags_list_3)
    expect(Tag.count).to be(2)
  end
end
