class TagArraySerializer < ActiveModel::Serializer
  attributes :id, :name, :taggings_count
end
