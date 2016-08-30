# == Schema Information
#
# Table name: tags
#
#  id             :uuid             not null, primary key
#  name           :string
#  taggings_count :integer          default(0)
#  created_at     :datetime
#

class Tag < ApplicationRecord
  has_many :taggings, dependent: :destroy

  validates_presence_of   :name
  validates_uniqueness_of :name, if: :validates_name_uniqueness?

  scope :recent,         -> { order('created_at DESC') }
  scope :filter_by_type, -> (type) { joins(:taggings).where(taggings: { taggable_type: type.classify }) }

  class << self
    def find_by_id_or_name(param)
      tag_id = where(name: param).or(where(id: param)).pluck(:id).min
      find(tag_id) rescue nil
    end

    def fetch_all(options)
      by_type = options['id'] if options['id'].present?

      tags = recent
      tags = tags.filter_by_type(by_type.classify).distinct if by_type.present?
      tags
    end

    def find_or_create_by_name(list)
      tags_list     = list['tags_list']
      taggable_id   = list['taggable_id']
      taggable_type = list['taggable_type']
      taggable_slug = list['taggable_slug'] if list['taggable_slug'].present?

      return [] if tags_list.empty? || taggable_id.blank? || taggable_type.blank?

      clear_tags(taggable_id, taggable_type)
      create_tags(tags_list, taggable_id, taggable_type, taggable_slug)
    end

    def clear_tags(taggable_id, taggable_type)
      Tagging.where(taggable_id: taggable_id, taggable_type: taggable_type).each do |tag|
        tag.destroy
      end
    end

    def create_tags(tags_list, taggable_id, taggable_type, taggable_slug)
      tags_list.map do |tag_name|
        current_tag = find_or_create_by(name: tag_name.downcase)
        Tagging.create(tag_id: current_tag.id, taggable_id: taggable_id, taggable_type: taggable_type, taggable_slug: taggable_slug)
      end
    end
  end

  def taggings_by_type
    types = taggings.pluck(:taggable_type)

    types.uniq.map do |taggable|
      base_path    = "#{ENV['API_GATEWAY_URL']}/#{taggable.downcase.parameterize.pluralize}"
      tagging_info = taggings.filter_by_type(taggable.classify).map do |tagging|
                       { id:         tagging.taggable_id,
                         slug:       tagging.taggable_slug,
                         type:       tagging.taggable_type,
                         uri:        "#{base_path}/#{tagging.taggable_id}",
                         created_at: tagging.created_at }
                     end

      { :"#{taggable.downcase.parameterize.pluralize}" => tagging_info }
    end
  end

  def validates_name_uniqueness?
    true
  end
end
