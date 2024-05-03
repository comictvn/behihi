
class Api::QuestionNavigationController < Api::BaseController
  before_action :doorkeeper_authorize!

  def navigate_question
    user_id = params[:user_id]
    question_id = params[:question_id]

    # Ensure User and Question exist
    user = User.find_by(id: user_id)
    question = Question.find_by(id: question_id)

    unless user && question
      render json: { error: 'Invalid user or question' }, status: :unprocessable_entity
      return
    end

    # Call the service to validate navigation
    service_response = QuestionNavigationService.new.validate_navigation(user_id, question_id)

    if service_response[:error]
      render json: { error: service_response[:error] }, status: :unprocessable_entity
    else
      render json: { message: 'Navigation allowed' }, status: :ok
    end
  end
end
