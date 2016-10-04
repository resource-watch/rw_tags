# frozen_string_literal: true
class TagArraySerializer < ApplicationSerializer
  attributes :id, :name, :taggings_count
end
