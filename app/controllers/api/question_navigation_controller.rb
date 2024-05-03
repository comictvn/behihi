
class Api::QuestionNavigationController < Api::BaseController
  before_action :doorkeeper_authorize!

  def next_question
    question_id = params[:questionId].to_i

    # Validate questionId parameter
    unless question_id.is_a?(Integer) && Question.exists?(question_id)
      render json: { error: "Question not found." }, status: :not_found
      return
    end

    # Ensure the user has selected an answer for the current question
    unless Answer.exists?(question_id: question_id, user: current_resource_owner)
      render json: { error: "Please select an answer before proceeding." }, status: :forbidden
      return
    end

    # Call the service to navigate to the next question
    service_response = QuestionNavigationService.new.navigate_next_question(
      user_id: current_resource_owner.id,
      question_id: question_id,
      selected_option: params[:selected_option]
    )

    if service_response[:success]
      progress_response = TestProgressService.update_progress(
        current_resource_owner.id,
        service_response[:current_question_number]
      )
      render json: progress_response.merge(
        status: 200,
        next_question_id: service_response[:next_question_id],
        message: "You have successfully navigated to the next question."
      ), status: :ok
    else
      render json: { error: service_response[:error] }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

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
