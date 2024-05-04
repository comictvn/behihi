
class Api::QuizController < Api::BaseController
  # before_action :doorkeeper_authorize!

  def evaluate_answer
    question_id = params[:questionId].to_i
    option_id = params[:optionId].to_i
    user_id = params[:userId].to_i

    # Validate input format
    unless question_id.is_a?(Integer) && option_id.is_a?(Integer) && user_id.is_a?(Integer)
      return render json: { message: "Invalid input format." }, status: :unprocessable_entity
    end

    # Validate existence
    question = Question.find_by(id: question_id)
    return render json: { message: "Question not found." }, status: :not_found unless question

    option = Option.find_by(id: option_id, question_id: question_id)
    return render json: { message: "Option not found for the given question." }, status: :not_found unless option

    user = User.find_by(id: user_id)
    return render json: { message: "User not found." }, status: :not_found unless user

    # Evaluate answer
    is_correct = option.is_correct
    explanation = option.explanation || "Lorem Ipsum is simply dummy text of the printing and typesetting industry." # Use actual explanation from the database if available
    feedback_message = is_correct ? "Correct answer!" : "Incorrect answer!"

    # Create answer record
    answer = Answer.create(
      user: user,
      question: question,
      option: option,
      is_correct: is_correct
    )

    # Return response
    render json: {
      status: 200,
      feedback: {
        isCorrect: is_correct,
        message: feedback_message,
        explanation: explanation
      },
      nextEnabled: true
    }, status: :ok
  rescue ActiveRecord::RecordNotFound => e
    render json: { message: e.message }, status: :not_found
  rescue StandardError => e
    render json: { message: e.message }, status: :internal_server_error
  end
end

