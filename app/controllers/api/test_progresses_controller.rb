
module Api
  class TestProgressesController < BaseController
    include OauthTokensConcern
    before_action :doorkeeper_authorize!

    def update_progress
      # Ensure userId and questionId are integers
      unless params[:userId].is_a?(Integer) && params[:questionId].is_a?(Integer)
        return render json: { message: "Invalid input format." }, status: :unprocessable_entity
      end

      begin
        user = User.find(params[:userId])
        question = Question.find(params[:questionId])
      rescue ActiveRecord::RecordNotFound => e
        return render json: { message: e.message }, status: :not_found
      end

      # Update test progress logic here
      # Assuming we have a method in the TestProgress model to handle the update
      test_progress = TestProgress.find_or_initialize_by(user_id: user.id)
      test_progress.current_question_number = question.id
      test_progress.total_questions = Question.count # Assuming total_questions is the count of all questions
      if test_progress.save
        render json: { status: 200, message: "Test progress updated successfully." }, status: :ok
      else
        render json: { message: test_progress.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def show
      user_id = params[:userId].to_i
      return render json: { error: "Invalid user ID format." }, status: :bad_request unless user_id > 0

      test_progress = TestProgress.find_by(user_id: user_id)
      return render json: { error: "Test progress not found." }, status: :not_found unless test_progress

      render json: test_progress, status: :ok
    end
  end
end
