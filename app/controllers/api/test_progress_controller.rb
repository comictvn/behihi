
class Api::TestProgressController < Api::BaseController
  before_action :doorkeeper_authorize!

  def update
    user_id = params[:userId]
    current_question_number = params[:current_question_number]

    # Validate user existence
    user = User.find_by(id: user_id)
    return render json: { message: "User not found." }, status: :not_found unless user

    # Validate current_question_number
    unless current_question_number.is_a?(Integer) && valid_question_number?(current_question_number)
      return render json: { message: "Invalid question number." }, status: :unprocessable_entity
    end

    # Update test progress
    service = TestProgressService::UpdateProgress.new(user_id, current_question_number)
    result = service.call

    render json: result, status: :ok
  rescue ActiveRecord::RecordNotFound => e
    render json: { message: e.message }, status: :not_found
  rescue StandardError => e
    render json: { message: e.message }, status: :internal_server_error
  end

  private

  def valid_question_number?(number)
    number > 0 && number <= Question.count
  end
end
