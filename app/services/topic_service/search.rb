
# rubocop:disable Style/ClassAndModuleChildren
class TopicService::Search
  attr_accessor :params, :topics, :query

  def initialize(params)
    @params = params
    @topics = Topic.all
  end

  def execute
    sanitize_and_validate_query
    search_topics
    order_by_relevance
    paginate_results
    log_search_query if params[:user_id].present?
    { topics: topics, total_count: topics.total_count, current_page: topics.current_page, limit_value: topics.limit_value }
  end

  private

  def sanitize_and_validate_query
    @query = ActiveRecord::Base.sanitize_sql_like(params[:search_query].to_s.strip)
    raise ArgumentError, 'Search query cannot be empty' if @query.empty?
  end

  def search_topics
    @topics = topics.where('lower(title) LIKE ?', "%#{@query.downcase}%")
  end

  def order_by_relevance
    # Assuming there is a method to calculate relevance or a column 'relevance' in the topics table
    @topics = topics.order('relevance DESC')
  end

  def paginate_results
    page_number = params.fetch(:page, 1).to_i
    limit = params.fetch(:limit, 10).to_i
    limit = 20 if limit > 20
    @topics = topics.page(page_number).per(limit)
  end

  def log_search_query
    FaqSearch.create(search_query: @query, user_id: params[:user_id])
  end
end
# rubocop:enable Style/ClassAndModuleChildren
