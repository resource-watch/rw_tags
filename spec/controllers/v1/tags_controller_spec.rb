require 'rails_helper'

RSpec.describe V1::TagsController, type: :controller do
  describe 'List, show and create tags' do
    let!(:tags_list) { { "tags_list"=>["tag1", "tag2", "Tag2", "Tag3"],
                       "taggable_type"=>"Dataset",
                       "taggable_id"=>"c547146d-de0c-47ff-a406-5125667fd533"} }

    let!(:tags) {
      Tag.find_or_create_by_name(tags_list)
      tags = Tag.all
    }

    let!(:tag_first) { tags[0] }

    it 'Index responds 200' do
      get :index
      expect(response.status).to eq 200
    end

    it 'Show responds 200' do
      get :show, params: { cat: 'find', id: tag_first.id }
      expect(response.status).to eq 200
    end

    it 'Taggable responds 200' do
      get :taggable, params: { cat: 'datasets', id: 'c547146d-de0c-47ff-a406-5125667fd533' }
      expect(response.status).to eq 200
    end

    it 'Create responds 201' do
      get :create, params: { tag: tags_list }
      expect(response.status).to eq 201
    end
  end
end
