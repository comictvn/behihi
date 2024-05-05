
class Api::TestQuestionsController < ApplicationController
  before_action :validate_id_format, only: [:show, :options]

  # GET /test-questions/:id
  def show
    begin
      question = Question.find_by!(id: params[:id])
      options = question.options.select(:id, :content)
      illustration_path = question.illustration.attached? ? url_for(question.illustration) : nil

      render json: {
        status: 200,
        question: {
          id: question.id,
          content: question.content,
          illustration: illustration_path
        },
        layout: {
          type: "grid_or_two_option", # Assuming this is a fixed value for now
          options: options
        }
      }, status: :ok
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Question not found." }, status: :not_found
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end

  # GET /test-questions/:questionId/options
  def options
    question = Question.find_by(id: params[:questionId])
    return render json: { error: "Question not found." }, status: :not_found unless question

    render json: { status: 200, options: question.options.select(:id, :content) }, status: :ok
  end

  private

  def validate_id_format
    id_param = params[:id] || params[:questionId]
    unless id_param.to_s.match?(/\A[0-9]+\z/)
      render json: { error: "Invalid question ID format." }, status: :bad_request
    end
  end
end
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end

  # GET /test-questions/:questionId/options
  def options
    question = Question.find_by(id: params[:questionId])
    return render json: { error: "Question not found." }, status: :not_found unless question

    render json: { status: 200, options: question.options.select(:id, :content) }, status: :ok
  end

  private

  def validate_id_format
    id_param = params[:id] || params[:questionId]
    unless id_param.to_s.match?(/\A[0-9]+\z/)
      render json: { error: "Invalid question ID format." }, status: :bad_request
    end
  end
end
