
class Api::TestProgressController < Api::BaseController
  before_action :doorkeeper_authorize!

  def update
    authenticate_and_validate_test_progress_update

    test_progress = TestProgressService.new(params[:user_id], params[:question_id]).update_progress

    render json: {
      status: 200,
      message: "Test progress updated successfully.",
      current_question_number: test_progress.current_question_number
    }, status: :ok
  end

  private

  def authenticate_and_validate_test_progress_update
    unless params[:user_id].is_a?(Integer) && params[:question_id].is_a?(Integer)
      render json: { message: "Invalid input format." }, status: :unprocessable_entity and return
    end

    begin
      User.find(params[:user_id])
    rescue ActiveRecord::RecordNotFound
      render json: { message: "User not found." }, status: :not_found and return
    end

    begin
      Question.find(params[:question_id])
    rescue ActiveRecord::RecordNotFound
      render json: { message: "Question not found." }, status: :not_found and return
    end
  end
end
