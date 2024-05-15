class TopicAccessValidator < BaseService
  include ActiveModel::Validations

  validate :validate_user_and_topic

  def initialize(user_id, topic_id)
    @user_id = user_id
    @topic_id = topic_id
  end

  def call
    return OpenStruct.new(success?: false, message: 'Invalid input', status: :bad_request) unless valid?

    user = User.find_by(id: @user_id)
    topic = Topic.find_by(id: @topic_id)

    return OpenStruct.new(success?: false, message: 'User not found', status: :not_found) if user.nil?
    return OpenStruct.new(success?: false, message: 'Topic not found', status: :not_found) if topic.nil?

    if TopicPolicy.new(user, topic).access?
      OpenStruct.new(success?: true, message: 'User is authorized to access the topic details', status: :ok)
    else
      OpenStruct.new(success?: false, message: 'User is not authorized to access the topic details', status: :unauthorized)
    end
  rescue StandardError => e
    OpenStruct.new(success?: false, message: e.message, status: :internal_server_error)
  end

  private

  def validate_user_and_topic
    errors.add(:user_id, 'must be an integer') unless @user_id.is_a?(Integer)
    errors.add(:topic_id, 'must be an integer') unless @topic_id.is_a?(Integer)
  end
end

# Assuming the TopicPolicy class exists and has an `access?` method that determines
# if a user has access to a topic. If it doesn't exist, it should be implemented as well.
class TopicPolicy
  def initialize(user, topic)
    @user = user
    @topic = topic
  end

  def access?
    # Logic to determine if user has access to the topic
    # This is a placeholder implementation
    @topic.user_id == @user.id
  end
end