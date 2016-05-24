class CreateTags < ActiveRecord::Migration[5.0]
  def change
    create_table :tags, id: :uuid, default: 'uuid_generate_v4()', force: true do |t|
      t.string  :name
      t.integer :taggings_count, default: 0

      t.datetime :created_at
    end

    add_index :tags, :name, unique: true
  end
end
