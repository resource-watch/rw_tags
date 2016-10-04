# frozen_string_literal: true
module V1
  class TopicsController < ApplicationController
    before_action :set_topic,     only: :show
    before_action :set_topicable, only: :topicable

    def index
      @topics = Topic.fetch_all(topic_type_filter)
      render json: @topics, each_serializer: TopicArraySerializer, root: false
    end

    def show
      render json: @topic, serializer: TopicSerializer, root: false
    end

    def topicable
      if @topicable.present?
        render json: @topicable, serializer: TaggingTopicableSerializer, root: false
      else
        render json: { errors: [{ status: 404, title: 'Topicgable not found' }] }, status: 404
      end
    end

    def create
      @topics = Topic.find_or_create_by_name(topic_params)
      if @topics.any?
        render json: { success: true, message: 'Topics created' }, status: 201
      else
        render json: { success: false, message: 'Error creating topic' }, status: 422
      end
    end

    private

      def topic_type_filter
        params.permit(:id)
      end

      def set_topic
        @topic = Topic.find_by_id_or_name(params[:id])
        render json: { errors: [{ status: 404, title: 'Record not found' }] }, status: 404 if @topic.nil?
      end

      def set_topicable
        @topicable = Topicable.find_by_id_or_slug(params[:id])
      end

      def topic_params
        params.require(:topic).permit!
      end
  end
end
