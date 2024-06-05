
module Api
  class TestProgressController < BaseController
    before_action :doorkeeper_authorize!

    def update
      user_id = params.require(:user_id)
      question_id = params.require(:question_id)

      begin
        message = TestProgressService.update_custom_question_progress(user_id: user_id, question_id: question_id)
        render json: { status: 200, message: message }, status: :ok
      rescue ActiveRecord::RecordNotFound => e
        render json: { message: e.message }, status: :not_found
      rescue Exceptions::AuthenticationError, Pundit::NotAuthorizedError
        # These exceptions are handled by the rescue_from statements in BaseController
      rescue ActiveRecord::RecordInvalid => e
        render json: { message: e.record.errors.full_messages }, status: :unprocessable_entity
      rescue => e
        render json: { message: "Could not update test progress atomically." }, status: :internal_server_error
      end
    end
  end
end
