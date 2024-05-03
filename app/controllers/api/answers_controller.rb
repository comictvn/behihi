
class Api::AnswersController < ApplicationController
  before_action :doorkeeper_authorize!

  def submit_answer
    user_id = params[:user_id]
    question_id = params[:question_id]
    selected_option = params[:selected_option]

    # Validate the selected option
    unless Option.exists?(content: selected_option, question_id: question_id)
      render json: { error: 'Invalid option selected.' }, status: :unprocessable_entity
      return
    end

    # Record the user's answer
    answer = Answer.new(user_id: user_id, question_id: question_id, selected_option: selected_option)

    if answer.save
      # Mark the answer as final
      answer.update(submitted_at: Time.current)

      # Prepare the response
      response = {
        answer_id: answer.id,
        message: 'Your answer has been successfully submitted.',
        redirect_info: {
          user_id: user_id,
          question_id: question_id
        }
      }

      render json: response, status: :ok
    else
      render json: { errors: answer.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end
end
