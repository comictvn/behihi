
class FaqSearchService::Create
  def initialize(user_id, search_query)
    @user = User.find(user_id)
    @search_query = search_query
  end

  def call
    validate_search_query
    question = find_or_create_question
    create_faq_search_record
    { question_id: question.id, options: question.options }
  end

  private

  def validate_search_query
    raise ArgumentError, 'Search query cannot be blank' if @search_query.blank?
  end

  def find_or_create_question
    question = Question.find_by('content LIKE ?', "%#{@search_query}%")
    return question if question.present?

    question = Question.create!(content: @search_query)
    create_default_options_for(question)
    question
  end

  def create_default_options_for(question)
    # Assuming we have a predefined set of default options
    default_options = ['Yes', 'No', 'Maybe']
    default_options.each do |option_content|
      question.options.create!(content: option_content, is_correct: false)
    end
  end

  def create_faq_search_record
    @user.faq_searches.create!(search_query: @search_query)
  end
end
