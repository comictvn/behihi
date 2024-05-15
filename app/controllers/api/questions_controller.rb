class Api::QuestionsController < Api::BaseController
  before_action :doorkeeper_authorize!

  def tips
    question = Question.find_by(id: params[:questionId])
    if question
      tips = question.options.where(is_correct: true).pluck(:content)
      render json: {
        status: 200,
        question: {
          id: question.id,
          content: question.content,
          illustration: question.illustration.attached? ? url_for(question.illustration) : nil,
          tips: tips
        }
      }, status: :ok
    else
      base_render_record_not_found
    end
  end
end