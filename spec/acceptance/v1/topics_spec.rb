require 'acceptance_helper'

module V1
  describe 'Topics', type: :request do
    context 'Create, show and list topics' do
      let!(:topics_list_1) { { "topics_list"    => ["topic1", "topic2", "Topic2", "Topic3"],
                               "topicable_type" => "Dataset",
                               "topicable_id"   => "c547146d-de0c-47ff-a406-5125667fd533",
                               "topicable_slug" => "dataset-first" } }
      let!(:topics_list_2) { { "topics_list"    => ["topic3"],
                               "topicable_type" => "Widget",
                               "topicable_id"   => "c547146d-de0c-47ff-a406-5125667fd555",
                               "topicable_slug" => "widget-first" } }

      let!(:topics) {
        Topic.find_or_create_by_name(topics_list_1)
        Topic.find_or_create_by_name(topics_list_2)
        topics = Topic.all
      }

      let!(:topic_first)  { topics[0] }
      let!(:topic_second) { topics[1] }
      let!(:topic_third)  { topics[2] }

      context 'List topics' do
        it 'Show list of all topics' do
          get '/topics'

          expect(status).to eq(200)
          expect(json.size).to eq(3)
        end

        it 'Show list of datasets topics' do
          get '/topics/datasets'

          expect(status).to eq(200)
          expect(json.size).to eq(3)
        end

        it 'Show list of widgets topics' do
          get '/topics/widgets'

          expect(status).to eq(200)
          expect(json.size).to eq(1)
        end
      end

      context 'Show specific topic' do
        it 'Show topic by id' do
          get "/topics/find/#{topic_first.id}"

          expect(status).to eq(200)
          expect(json['attributes']['name']).to eq('topic1')
        end

        it 'Show topic by name' do
          get "/topics/find/#{topic_first.name}"

          expect(status).to eq(200)
          expect(json['attributes']['name']).to eq('topic1')
        end
      end

      context 'Show specific topicable' do
        it 'Show dataset by id and list topics' do
          get '/topics/datasets/c547146d-de0c-47ff-a406-5125667fd533'

          expect(status).to eq(200)
          expect(json['attributes']['slug']).to        eq('dataset-first')
          expect(json['attributes']['topics'].length).to eq(3)
        end

        it 'Show widget by slug and list topics' do
          get '/topics/widgets/c547146d-de0c-47ff-a406-5125667fd555'

          expect(status).to eq(200)
          expect(json['attributes']['slug']).to        eq('widget-first')
          expect(json['attributes']['topics'].length).to eq(1)
        end

        it 'Show error if topicging not found' do
          get '/topics/datasets/not-existing'

          expect(status).to eq(404)
          expect(json_main['errors']).to eq([{"status"=>404, "title"=>"Topicgable not found"}])
        end
      end

      context 'Create topic' do
        let!(:topics_list_3) { { "topics_list"=>["topic4"],
                               "topicable_type"=>"Dataset",
                               "topicable_id"=>"c547146d-de0c-47ff-a406-5125667fd535" } }

        it 'Allow to create topic' do
          post '/topics', params: { topic: topics_list_3 }

          expect(status).to eq(201)
          expect(Topic.count).to eq(4)
        end
      end
    end
  end
end
