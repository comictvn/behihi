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

    return OpenStruct.new(success?: false, message: 'User or Topic not found', status: :not_found) if user.nil? || topic.nil?

    if topic.user_id == user.id
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