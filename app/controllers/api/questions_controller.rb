module Api
  class QuestionsController < BaseController
    before_action :doorkeeper_authorize!, only: [:additional_info]

    def additional_info
      question = Question.find_by(id: params[:questionId])
      return base_render_record_not_found unless question

      render json: {
        status: 200,
        additional_info: "Lorem Ipsum is simply dummy text of the printing and typesetting industry."
      }, status: :ok
    end
  end
end