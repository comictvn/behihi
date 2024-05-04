
class Api::TestProgressController < Api::BaseController
  before_action :doorkeeper_authorize!

  def update
    user_id = params[:user_id].to_i
    question_id = params[:question_id].to_i

    return render json: { message: "Invalid input format." }, status: :unprocessable_entity unless user_id.is_a?(Integer) && question_id.is_a?(Integer)

    begin
      user = User.find(user_id)
    rescue ActiveRecord::RecordNotFound
      return render json: { message: "User not found." }, status: :not_found
    end

    begin
      question = Question.find(question_id)
    rescue ActiveRecord::RecordNotFound
      return render json: { message: "Question not found." }, status: :not_found
    end

    policy = TestAnswerPolicy.new(current_resource_owner, nil)
    unless policy.create?
      return render json: { message: "Unauthorized" }, status: :forbidden
    end

    begin
      test_progress = TestProgressService.new(user_id, question_id).update_progress
      render json: {
        status: 200,
        message: "Test progress updated successfully.",
        current_question_number: test_progress[:current_question_number]
      }, status: :ok
    rescue StandardError => e
      render json: { message: e.message }, status: :unprocessable_entity
    end
  end
end
