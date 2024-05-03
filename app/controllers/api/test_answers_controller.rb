
class Api::TestAnswersController < Api::BaseController
  before_action :doorkeeper_authorize!

  def record_answer
    user_id = params[:user_id].to_i
    question_id = params[:question_id].to_i
    selected_option = params[:selected_option]

    return render json: { message: "Invalid input format." }, status: :unprocessable_entity unless user_id.is_a?(Integer) && question_id.is_a?(Integer) && selected_option.is_a?(String)

    user = User.find_by(id: user_id)
    return render json: { message: "User not found." }, status: :unprocessable_entity if user.nil?

    question = Question.find_by(id: question_id)
    return render json: { message: "Question not found." }, status: :unprocessable_entity if question.nil?

    option = question.options.find_by(content: selected_option)
    return render json: { message: "Invalid option selected." }, status: :unprocessable_entity if option.nil?

    is_correct = option.is_correct
    answer = user.answers.create!(
      question: question,
      selected_option: selected_option,
      submitted_at: Time.current,
      is_correct: is_correct
    )

    render json: {
      status: 200,
      message: "Your answer has been recorded successfully.",
      is_correct: is_correct
    }, status: :ok
  rescue ActiveRecord::RecordInvalid => e
    base_render_unprocessable_entity(e)
  end
end
