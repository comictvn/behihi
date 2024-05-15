class Api::TopicsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: [:show, :validate_access]
  before_action :validate_topic_access, only: [:show, :update, :destroy]

  # ... other actions ...

  def validate_access
    topic_id = params[:topic_id].to_i
    user_id = current_user.id # Assuming current_user is set after authentication
    result = TopicAccessValidator.new(user_id, topic_id).call

    if result.success?
      render json: { status: result.status, authorized: true, message: result.message }, status: :ok
    else
      render json: { status: result.status, authorized: false, message: result.message }, status: result.status
    end
  rescue Pundit::NotAuthorizedError
    render json: { message: 'User is not authorized to access the topic details' }, status: :forbidden
  end

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