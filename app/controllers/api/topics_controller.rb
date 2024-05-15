class Api::TopicsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: [:show]
  before_action :validate_topic_access, only: [:show, :update, :destroy]

  # ... other actions ...

  def show
    begin
      topic_details = RetrieveTopicDetailsService.new.execute(params[:id].to_i)
      render json: { status: 200, topic: topic_details }, status: :ok
    rescue ActiveRecord::RecordNotFound => e
      render json: { message: e.message }, status: :not_found
    rescue ArgumentError => e
      render json: { message: e.message }, status: :bad_request
    end
  end

  private

  def validate_topic_access
    topic_id = params[:id]
    user_id = current_user.id
    validator = Topics::TopicAccessValidator.new(user_id, topic_id)

    if validator.valid?
      authorize Topic.find(topic_id)
    else
      render json: { message: validator.error_message }, status: validator.error_status
    end
  end
end