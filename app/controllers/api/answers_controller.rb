
class Api::AnswersController < Api::BaseController
  before_action :doorkeeper_authorize!

  def create
    # Parse and validate request parameters
    user_id = params[:user_id].to_i
    question_id = params[:question_id].to_i
    option_id = params[:option_id].to_i

    # Check if parameters are integers
    unless user_id.is_a?(Integer) && question_id.is_a?(Integer) && option_id.is_a?(Integer)
      return render json: { status: 422, message: "Invalid input format." }, status: :unprocessable_entity
    end

    # Use the RecordAnswer service to record the user's answer
    result = RecordAnswer.new(user_id, question_id, option_id).execute

    # Render the JSON response with the appropriate HTTP status code
    render json: result, status: result[:status] == 200 ? :ok : result[:status]
  end
end
