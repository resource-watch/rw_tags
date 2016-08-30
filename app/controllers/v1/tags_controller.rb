module V1
  class TagsController < ApplicationController
    before_action :set_tag,      only: :show
    before_action :set_taggable, only: :taggable

    def index
      @tags = Tag.fetch_all(tag_type_filter)
      render json: @tags, each_serializer: TagArraySerializer, root: false
    end

    def show
      render json: @tag, serializer: TagSerializer, root: false
    end

    def taggable
      if @taggable.present?
        render json: @taggable, serializer: TaggingTopicableSerializer, root: false
      else
        render json: { errors: [{ status: 404, title: 'Taggable not found' }] }, status: 404
      end
    end

    def create
      @tags = Tag.find_or_create_by_name(tag_params)
      if @tags.any?
        render json: { success: true, message: 'Tags created' }, status: 201
      else
        render json: { success: false, message: 'Error creating tag' }, status: 422
      end
    end

    private

      def tag_type_filter
        params.permit(:id, tag: {})
      end

      def set_tag
        @tag = Tag.find_by_id_or_name(params[:id])
      end

      def set_taggable
        @taggable = Tagging.find_by_id_or_slug(params[:id])
      end

      def tag_params
        params.require(:tag).permit!
      end
  end
end
