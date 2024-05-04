
class FaqSearchService::FindOrCreateQuestion
  def initialize(search_query, user_id)
    @search_query = search_query
    @user_id = user_id
  end

  def call
    return unless User.exists?(@user_id)

    if @search_query.blank?
      question = Question.where(content: 'default').first
    else
      question = Question.find_by('content LIKE ?', "%#{@search_query}%")
      unless question
        question = Question.create(content: @search_query)
        create_default_options_for(question)
      end
    end

    options = question.options
    { question_id: question.id, options: options }
  end

  private

  def create_default_options_for(question)
    # Assuming we have a predefined list of default options
    default_options = ['Yes', 'No', 'Maybe']
    default_options.each do |option_content|
      question.options.create(content: option_content)
    end
  end
end
