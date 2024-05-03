
class Api::SelectionsController < Api::BaseController
  before_action :doorkeeper_authorize!

  def create
    question = Question.find_by(id: params[:questionId])
    return render json: { message: "Question not found." }, status: :not_found unless question

    user = User.find_by(id: selection_params[:user_id])
    return render json: { message: "User not found." }, status: :not_found unless user

    option = question.options.find_by(content: selection_params[:selected_option])
    return render json: { message: "Invalid option selected." }, status: :unprocessable_entity unless option

    answer = Answer.new(user: user, question: question, option: option)

    if answer.save
      render json: { status: 200, message: 'Your answer has been recorded successfully.' }, status: :ok
    else
      render json: { message: answer.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound => e
    render json: { message: e.message }, status: :not_found
  end

  private

  def selection_params
    params.require(:selection).permit(:user_id, :selected_option)
  end
end
