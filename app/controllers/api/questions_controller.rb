
module Api
  class QuestionsController < BaseController
    before_action :doorkeeper_authorize!, only: [:show_with_answers]

    def show_with_answers
      question = Question.find(params[:questionId])
      options = question.options

      render json: {
        status: 200,
        question: {
          id: question.id,
          content: question.content,
          illustration: question.illustration.attached? ? url_for(question.illustration) : nil
        },
        options: options.map { |option| { id: option.id, content: option.content } }
      }, status: :ok
    rescue ActiveRecord::RecordNotFound => e
      base_render_record_not_found(e)
    end
  end
end
