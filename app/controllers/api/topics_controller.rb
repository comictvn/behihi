class Api::TopicsController < Api::BaseController
  before_action :validate_topic_access, only: [:show, :update, :destroy]

  # ... other actions ...

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