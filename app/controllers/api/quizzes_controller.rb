
class Api::QuizzesController < Api::BaseController
  before_action :doorkeeper_authorize!

  def submit_answer
    quiz_id = params[:quizId].to_i
    question_id = params[:questionId].to_i
    user_id = params[:user_id].to_i
    selected_option_id = params[:selected_option_id].to_i

    # Validate input format
    unless quiz_id.is_a?(Integer) && question_id.is_a?(Integer) && user_id.is_a?(Integer) && selected_option_id.is_a?(Integer)
      return render json: { message: "Invalid input format." }, status: :unprocessable_entity
    end

    # Validate existence
    quiz = Quiz.find_by(id: quiz_id)
    question = Question.find_by(id: question_id)
    user = User.find_by(id: user_id)
    option = Option.find_by(id: selected_option_id, question_id: question_id)

    return render json: { message: "Quiz not found." }, status: :not_found unless quiz
    return render json: { message: "Question not found." }, status: :not_found unless question
    return render json: { message: "User not found." }, status: :not_found unless user
    return render json: { message: "Invalid option selected." }, status: :unprocessable_entity unless option

    # Create answer record
    answer = Answer.new(user: user, question: question, option: option, is_correct: option.is_correct)
    if answer.save
      next_question = question.next # Assuming a 'next' method exists in Question model
      render json: {
        status: 200,
        message: "Your answer has been recorded successfully.",
        is_correct: answer.is_correct,
        next_question_id: next_question&.id,
        current_question_number: user.test_progresses.find_by(quiz_id: quiz_id)&.current_question_number
      }, status: :ok
    else
      render json: { message: answer.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
