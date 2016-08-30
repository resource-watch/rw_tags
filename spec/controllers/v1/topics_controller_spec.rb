require 'rails_helper'

RSpec.describe V1::TopicsController, type: :controller do
  describe 'List, show and create topics' do
    let!(:topics_list) { { "topics_list"=>["topic1", "topic2", "Topic2", "Topic3"],
                       "topicable_type"=>"Dataset",
                       "topicable_id"=>"c547146d-de0c-47ff-a406-5125667fd533"} }

    let!(:topics) {
      Topic.find_or_create_by_name(topics_list)
      topics = Topic.all
    }

    let!(:topic_first) { topics[0] }

    it 'Index responds 200' do
      get :index
      expect(response.status).to eq 200
    end

    it 'Show responds 200' do
      get :show, params: { cat: 'find', id: topic_first.id }
      expect(response.status).to eq 200
    end

    it 'Topicable responds 200' do
      get :topicable, params: { cat: 'datasets', id: 'c547146d-de0c-47ff-a406-5125667fd533' }
      expect(response.status).to eq 200
    end

    it 'Create responds 201' do
      get :create, params: { topic: topics_list }
      expect(response.status).to eq 201
    end
  end
end
