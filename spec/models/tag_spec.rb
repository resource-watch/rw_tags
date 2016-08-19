# == Schema Information
#
# Table name: tags
#
#  id             :uuid             not null, primary key
#  name           :string
#  taggings_count :integer          default(0)
#  created_at     :datetime
#

require 'rails_helper'

RSpec.describe Tag, type: :model do
  let!(:tags_list) { { "tags_list"=>["tag1", "tag2", "Tag2", "Tag3"],
                       "taggable_type"=>"Dataset",
                       "taggable_id"=>"c547146d-de0c-47ff-a406-5125667fd533"} }

  let!(:tags) {
    Tag.find_or_create_by_name(tags_list)
    tags = Tag.all
  }

  let!(:tag_first)  { tags[0] }
  let!(:tag_second) { tags[1] }
  let!(:tag_third)  { tags[2] }

  it 'Is valid' do
    expect(tag_first).to      be_valid
    expect(tag_first.name).to eq('tag1')
  end

  it 'Save tags as downcase and unique' do
    expect(tags.length).to     be(3)
    expect(tag_first.name).to  eq('tag3')
    expect(tag_second.name).to eq('tag1')
    expect(tag_third.name).to  eq('tag2')
  end

  it 'Do not allow to create tag without name' do
    tag_reject = Tag.new(name: '')

    tag_reject.valid?
    expect {tag_reject.save!}.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Name can't be blank")
  end

  it 'Do not allow to create tag with name douplications' do
    expect(tag_first).to be_valid
    tag_reject = Tag.new(name: 'tag1')

    tag_reject.valid?
    expect {tag_reject.save!}.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Name has already been taken")
  end
end
