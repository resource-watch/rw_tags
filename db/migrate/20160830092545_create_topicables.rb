class CreateTopicables < ActiveRecord::Migration[5.0]
  def change
    create_table :topicables, id: :uuid, default: 'uuid_generate_v4()', force: true do |t|
      t.uuid    :topic_id
      t.uuid    :topicable_id
      t.string  :topicable_type
      t.string  :topicable_slug

      t.datetime :created_at
    end

    add_index :topicables, ['topic_id', 'topicable_id',   'topicable_type'], name: 'topicables_index',      unique: true
    add_index :topicables, ['topic_id', 'topicable_slug', 'topicable_type'], name: 'topicables_slug_index', unique: true
    add_index :topicables, ['topicable_id', 'topicable_type']
  end
end
