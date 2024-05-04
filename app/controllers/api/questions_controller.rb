
module Api
  class QuestionsController < BaseController
    before_action :doorkeeper_authorize!, only: [:show_with_answers]
    before_action :doorkeeper_authorize!, only: [:show]
    
    def show_with_answers
      question = Question.find(params[:id])
      options = question.options

      render json: {
        status: 200,
        question: {
          id: question.id,
          content: question.content,
          illustration: question.illustration.attached? ? url_for(question.illustration) : nil
        },
        options: options.map { |option| { id: option.id, content: option.content } }
      }
    rescue ActiveRecord::RecordNotFound => e
      base_render_record_not_found(e)
    end

    def show
      service = RetrieveQuestionAndOptions.new(question_id: params[:question_id])
      result = service.call

      render json: {
        question_content: result[:question_content],
        options_list: result[:options_list].map { |option| { id: option.id, content: option.content } },
        illustration_file: result[:illustration_file]&.attached? ? url_for(result[:illustration_file]) : nil
      }, status: :ok
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Question not found' }, status: :not_found
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end
end
