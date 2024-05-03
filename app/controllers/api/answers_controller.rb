
class Api::AnswersController < ApplicationController
  before_action :doorkeeper_authorize!

  def submit_answer
    user_id = params[:user_id].to_i
    question_id = params[:question_id].to_i
    selected_option = params[:selected_option]

    # Validate input format
    unless user_id.is_a?(Integer) && question_id.is_a?(Integer) && selected_option.is_a?(String)
      render json: { error: "Invalid input format." }, status: :unprocessable_entity
      return
    end

    # Validate user and question existence
    unless User.exists?(user_id)
      render json: { error: "User not found." }, status: :bad_request
      return
    end

    unless Question.exists?(question_id)
      render json: { error: "Question not found." }, status: :bad_request
      return
    end

    # Validate the selected option
    unless Option.exists?(content: selected_option, question_id: question_id)
      render json: { error: "Invalid option selected." }, status: :bad_request
      return
    end

    # Use the SubmitAnswer service to submit the answer
    begin
      submit_answer_service = AnswerService::SubmitAnswer.new(user_id, question_id, selected_option)
      response = submit_answer_service.execute
      render json: {
        status: 200,
        answer_id: response[:answer_id],
        message: "Your answer has been submitted successfully. Please proceed to the feedback page."
      }, status: :ok
    rescue AnswerService::SubmitAnswer::ValidationError => e
      render json: { error: e.message }, status: :unprocessable_entity
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end
end
