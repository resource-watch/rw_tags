require 'acceptance_helper'

module V1
  describe 'Tags', type: :request do
    context 'Create, show and list tags' do
      let!(:tags_list_1) { { "tags_list"=>["tag1", "tag2", "Tag2", "Tag3"],
                             "taggable_type"=>"Dataset",
                             "taggable_id"=>"c547146d-de0c-47ff-a406-5125667fd533",
                             "taggable_slug"=>"dataset-first" } }
      let!(:tags_list_2) { { "tags_list"=>["tag3"],
                             "taggable_type"=>"Widget",
                             "taggable_id"=>"c547146d-de0c-47ff-a406-5125667fd555",
                             "taggable_slug"=>"widget-first" } }

      let!(:tags) {
        Tag.find_or_create_by_name(tags_list_1)
        Tag.find_or_create_by_name(tags_list_2)
        tags = Tag.all
      }

      let!(:tag_first)  { tags[0] }
      let!(:tag_second) { tags[1] }
      let!(:tag_third)  { tags[2] }

      context 'List tags' do
        it 'Show list of all tags' do
          get '/tags'

          expect(status).to eq(200)
          expect(json.size).to eq(3)
        end

        it 'Show list of datasets tags' do
          get '/tags/datasets'

          expect(status).to eq(200)
          expect(json.size).to eq(3)
        end

        it 'Show list of widgets tags' do
          get '/tags/widgets'

          expect(status).to eq(200)
          expect(json.size).to eq(1)
        end
      end

      context 'Show specific tag' do
        it 'Show tag by id' do
          get "/tags/find/#{tag_first.id}"

          expect(status).to eq(200)
          expect(json['attributes']['name']).to eq('tag1')
        end

        it 'Show tag by name' do
          get "/tags/find/#{tag_first.name}"

          expect(status).to eq(200)
          expect(json['attributes']['name']).to eq('tag1')
        end
      end

      context 'Show specific taggable' do
        it 'Show dataset by id and list tags' do
          get '/tags/datasets/c547146d-de0c-47ff-a406-5125667fd533'

          expect(status).to eq(200)
          expect(json['attributes']['slug']).to        eq('dataset-first')
          expect(json['attributes']['tags'].length).to eq(3)
        end

        it 'Show widget by slug and list tags' do
          get '/tags/widgets/c547146d-de0c-47ff-a406-5125667fd555'

          expect(status).to eq(200)
          expect(json['attributes']['slug']).to        eq('widget-first')
          expect(json['attributes']['tags'].length).to eq(1)
        end

        it 'Show error if tagging not found' do
          get '/tags/datasets/not-existing'

          expect(status).to eq(404)
          expect(json_main['errors']).to eq([{"status"=>404, "title"=>"Taggable not found"}])
        end
      end

      context 'Create tag' do
        let!(:tags_list_3) { { "tags_list"=>["tag4"],
                               "taggable_type"=>"Dataset",
                               "taggable_id"=>"c547146d-de0c-47ff-a406-5125667fd535" } }

        it 'Allow to create tag' do
          post '/tags', params: { tag: tags_list_3 }

          expect(status).to eq(201)
          expect(Tag.count).to eq(4)
        end
      end
    end
  end
end
