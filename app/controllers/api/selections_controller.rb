
class Api::SelectionsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: [:create]

  def create
    question = Question.find_by(id: params[:questionId])
    return render json: { message: "Question not found." }, status: :not_found unless question

    user = User.find_by(id: selection_params[:user_id])
    return render json: { message: "User not found." }, status: :not_found unless user
    authorize user, policy_class: SelectionPolicy

    option = question.options.find_by(content: selection_params[:selected_option])
    return render json: { message: "Invalid option selected." }, status: :unprocessable_entity unless option

    answer = Answer.new(user: user, question: question, option: option)

    if answer.save
      render 'create.json.jbuilder', status: :ok
    else
      render json: { message: answer.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound => e
    error_response(e.message, :not_found)
  rescue => e
    error_response(e.message, :internal_server_error)
  end

  private

  def selection_params
    params.require(:selection).permit(:user_id, :selected_option)
  end

  def error_response(message, status)
    render json: { message: message }, status: status
  end
end
