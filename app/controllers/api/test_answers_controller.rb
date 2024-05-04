
class Api::TestAnswersController < Api::BaseController
  before_action :doorkeeper_authorize!
  include TestAnswerHelper

  def record_answer
    user_id = params[:user_id].to_i
    question_id = params[:question_id].to_i
    selected_option = params[:selected_option]

    unless user_id.is_a?(Integer) && question_id.is_a?(Integer) && selected_option.is_a?(String)
      return render json: { message: "Invalid input format." }, status: :unprocessable_entity
    end

    user = User.find_by(id: user_id)
    return render json: { message: "User not found." }, status: :unprocessable_entity if user.nil?

    question = Question.find_by(id: question_id)
    return render json: { message: "Question not found." }, status: :unprocessable_entity if question.nil?

    option = Option.find_by(question_id: question_id, content: selected_option)
    return render json: { message: "Invalid option selected." }, status: :unprocessable_entity if option.nil?

    authorize user, policy_class: TestAnswerPolicy

    result = TestAnswerService.record_answer(
      user_id: user_id,
      question_id: question_id,
      selected_option: selected_option
    )

    if result[:success]
      render json: {
        status: 200,
        message: "Your answer has been recorded successfully.",
        is_correct: result[:is_correct]
      }, status: :ok
    else
      render json: { message: result[:error] }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordInvalid => e
    base_render_unprocessable_entity(e)
  end
end
