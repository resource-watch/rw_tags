# == Schema Information
#
# Table name: tags
#
#  id             :uuid             not null, primary key
#  name           :string
#  taggings_count :integer          default(0)
#  created_at     :datetime
#

class TagSerializer < ActiveModel::Serializer
  attributes :id, :name, :taggings_count, :tagged_objects

  def tagged_objects
    object.taggings_by_type
  end
end
