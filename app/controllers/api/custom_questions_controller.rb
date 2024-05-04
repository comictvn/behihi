
class Api::CustomQuestionsController < Api::BaseController
  before_action :doorkeeper_authorize!

  def submit_custom_question
    user_id = params[:user_id]
    search_query = params[:search_query]

    begin
      user = User.find(user_id)
    rescue ActiveRecord::RecordNotFound
      render json: { error: "User not found." }, status: :not_found and return
    end

    if search_query.blank?
      search_query = 'default'
      error_message = "No custom question entered; default question provided."
    end

    begin
      faq_search_service = FaqSearchService::Create.new(user_id, search_query)
      result = faq_search_service.call
      question = Question.find(result[:question_id])
      options = question.options.map do |option|
        { id: option.id, content: option.content }
      end

      response_body = {
        status: 200,
        question: {
          id: question.id,
          content: question.content,
          illustration: question.illustration
        },
        options: options
      }
      response_body[:error] = error_message if error_message.present?
      render json: response_body, status: :ok
    rescue ArgumentError => e
      render json: { error: e.message }, status: :unprocessable_entity
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end

  rescue_from ActiveRecord::RecordInvalid do |exception|
    render json: { error: exception.message }, status: :unprocessable_entity
  end
end
