
class RetrieveQuestionAndOptions < BaseService
  attr_reader :question_id

  def initialize(question_id:)
    @question_id = question_id
  end

  def call
    question = Question.find_by!(id: question_id)
    options = question.options
    illustration = question.illustration.attached? ? question.illustration.blob : nil

    {
      question_content: question.content,
      options_list: options.map { |option| { id: option.id, content: option.content } },
      illustration_file: illustration
    }
  rescue ActiveRecord::RecordNotFound => e
    logger.error "Question not found: #{e.message}"
    raise
  rescue StandardError => e
    logger.error "Error retrieving question and options: #{e.message}"
    raise
  end
end
