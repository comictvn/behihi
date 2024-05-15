class RetrieveTopicDetailsService < BaseService
  def execute(topic_id)
    raise ArgumentError, 'topic_id must be an integer' unless topic_id.is_a?(Integer)
    raise ActiveRecord::RecordNotFound, 'Topic not found' unless Topic.exists?(topic_id)

    topic_detail = TopicDetail.find_by(topic_id: topic_id)
    raise ActiveRecord::RecordNotFound, 'Topic detail not found' if topic_detail.nil?

    topic_with_detail = Topic.joins(:topic_details)
                             .select('topics.id, topics.title, topic_details.content')
                             .find(topic_id)

    { id: topic_with_detail.id, title: topic_with_detail.title, content: topic_with_detail.content }
  end
end