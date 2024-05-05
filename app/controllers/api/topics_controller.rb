
class Api::TopicsController < ApplicationController
  before_action :doorkeeper_authorize!

  def search
    begin
      search_service = TopicService::Search.new(search_params)
      result = search_service.execute
      render json: result, status: :ok
    rescue ArgumentError => e
      render json: { error: e.message }, status: :unprocessable_entity
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end

  private

  def search_params
    params.permit(:search_query, :user_id)
  end
end
