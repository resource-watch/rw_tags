class CreateTaggings < ActiveRecord::Migration[5.0]
  def change
    create_table :taggings, id: :uuid, default: 'uuid_generate_v4()', force: true do |t|
      t.uuid    :tag_id
      t.uuid    :taggable_id
      t.string  :taggable_type
      t.string  :taggable_slug

      t.datetime :created_at
    end

    add_index :taggings, ['tag_id', 'taggable_id',   'taggable_type'], name: 'taggings_index',      unique: true
    add_index :taggings, ['tag_id', 'taggable_slug', 'taggable_type'], name: 'taggings_slug_index', unique: true
    add_index :taggings, ['taggable_id', 'taggable_type']
  end
end
