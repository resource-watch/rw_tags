class CreateTopics < ActiveRecord::Migration[5.0]
  def change
    create_table :topics, id: :uuid, default: 'uuid_generate_v4()', force: true do |t|
      t.string  :name
      t.integer :topicables_count, default: 0

      t.datetime :created_at
    end

    add_index :topics, :name, unique: true
  end
end
