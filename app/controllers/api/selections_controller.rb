
class Api::SelectionsController < Api::BaseController
  before_action :doorkeeper_authorize!

  def create
    question_id = params[:id]
    user_id = params[:user_id]
    option_id = params[:option_id]

    validate_user(user_id)
    validate_question(question_id)
    validate_option(option_id, question_id)

    answer = Answer.new(user_id: user_id, question_id: question_id, option_id: option_id)

    if answer.save
      render json: { status: 200, message: "Your answer has been recorded successfully." }, status: :ok
    else
      render json: { message: answer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def validate_user(user_id)
    User.find(user_id)
  rescue ActiveRecord::RecordNotFound
    render json: { message: "User not found." }, status: :not_found
  end

  def validate_question(question_id)
    Question.find(question_id)
  rescue ActiveRecord::RecordNotFound
    render json: { message: "Question not found." }, status: :not_found
  end

  def validate_option(option_id, question_id)
    option = Option.find_by(id: option_id, question_id: question_id)
    raise ActiveRecord::RecordNotFound unless option
  rescue ActiveRecord::RecordNotFound
    render json: { message: "Invalid option selected." }, status: :not_found
  end
end
