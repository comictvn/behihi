
class Api::TestQuestionsController < Api::BaseController
  def show_with_answers
    question = Question.find_by!(id: params[:id])
    options = question.options.map do |option|
      {
        id: option.id,
        content: option.content
      }
    end
    render json: {
      status: 200,
      question: {
        id: question.id,
        content: question.content,
        illustration: question.illustration.attached? ? url_for(question.illustration) : nil
      },
      options: options
    }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { message: "Question not found." }, status: :not_found
  end
end
