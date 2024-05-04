
class Api::AnswersController < ApplicationController
  # before_action :doorkeeper_authorize!
  
  def record_answer
    user_id = params[:user_id].to_i
    question_id = params[:question_id].to_i
    selected_option = params[:selected_option]

    # Validate input format
    unless user_id.is_a?(Integer) && question_id.is_a?(Integer) && selected_option.is_a?(String)
      render json: { error: 'Invalid input format.' }, status: :unprocessable_entity
      return
    end

    # Validate existence
    unless User.exists?(id: user_id)
      render json: { error: 'User not found.' }, status: :not_found
      return
    end

    unless Question.exists?(id: question_id)
      render json: { error: 'Question not found.' }, status: :not_found
      return
    end

    # Use the service to record the answer
    response = AnswerService::RecordUserAnswer.new(user_id, question_id, selected_option).execute
    render json: response, status: :ok
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def submit_answer
    user_id = params[:user_id].to_i
    question_id = params[:question_id].to_i
    selected_option = params[:selected_option]

    # Use the service to record the answer
    begin
      response = AnswerService::RecordUserAnswer.new(user_id, question_id, selected_option).execute
      render json: response, status: :ok
    rescue AnswerService::RecordUserAnswer::ValidationError => e
      render json: { error: e.message }, status: :unprocessable_entity
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: e.message }, status: :not_found
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end

  private

  def answer_params
    params.permit(:user_id, :question_id, :selected_option)
  end
end
