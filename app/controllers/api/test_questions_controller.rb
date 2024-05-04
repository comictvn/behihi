
module Api
  class TestQuestionsController < BaseController
    before_action :doorkeeper_authorize!, only: [:show]

    def show
      question_service = QuestionService::RetrieveQuestion.new
      question_data = question_service.call(question_id: params[:id])
      render json: { status: 200, question: question_data }, status: :ok
    rescue ActiveRecord::RecordNotFound => e
      base_render_record_not_found(e)
    rescue Pundit::NotAuthorizedError => e
      base_render_unauthorized_error(e)
    end
  end
end
