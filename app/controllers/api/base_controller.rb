# typed: ignore
module Api
  include Pundit
  class BaseController < ActionController::API
    include ActionController::Cookies
    include Pundit::Authorization

    # =======End include module======

    rescue_from ActiveRecord::RecordNotFound, with: :base_render_record_not_found
    rescue_from ActiveRecord::RecordInvalid, with: :base_render_unprocessable_entity
    rescue_from Exceptions::AuthenticationError, with: :base_render_authentication_error
    rescue_from ActiveRecord::RecordNotUnique, with: :base_render_record_not_unique
    rescue_from Pundit::NotAuthorizedError, with: :base_render_unauthorized_error

    def error_response(resource, error)
      {
        success: false,
        full_messages: resource&.errors&.full_messages,
        errors: resource&.errors,
        error_message: error.message,
        backtrace: error.backtrace
      }
    end

    private

    def base_render_record_not_found(_exception)
      render json: { message: I18n.t('common.404') }, status: :not_found
    end

    def base_render_unprocessable_entity(exception)
      render json: { message: exception.record.errors.full_messages }, status: :unprocessable_entity
    end

    def base_render_authentication_error(_exception)
      render json: { message: I18n.t('common.404') }, status: :not_found
    end

    def base_render_unauthorized_error(_exception)
      render json: { message: I18n.t('common.errors.unauthorized_error') }, status: :unauthorized
    end

    def base_render_record_not_unique
      render json: { message: I18n.t('common.errors.record_not_uniq_error') }, status: :forbidden
    end

    def record_user_answer
      user_id = params[:user_id].to_i
      question_id = params[:question_id].to_i
      selected_option = params[:selected_option]

      return render json: { message: "Invalid input format." }, status: :unprocessable_entity unless user_id.is_a?(Integer) && question_id.is_a?(Integer) && selected_option.is_a?(String)

      user = User.find_by(id: user_id)
      return render json: { message: "User not found." }, status: :not_found unless user

      question = Question.find_by(id: question_id)
      return render json: { message: "Question not found." }, status: :not_found unless question

      options = question.options.pluck(:content)
      return render json: { message: "Invalid option selected." }, status: :unprocessable_entity unless options.include?(selected_option)

      begin
        AnswerService::RecordAnswer.new(
          user_id: user_id,
          question_id: question_id,
          selected_option: selected_option
        ).execute
        render json: { status: 200, message: "Your answer has been recorded successfully." }, status: :ok
      rescue StandardError => e
        render json: { message: e.message }, status: :unprocessable_entity
      end
    end

    def custom_token_initialize_values(resource, client)
      token = CustomAccessToken.create(
        application_id: client.id,
        resource_owner: resource,
        scopes: resource.class.name.pluralize.downcase,
        expires_in: Doorkeeper.configuration.access_token_expires_in.seconds
      )
      @access_token = token.token
      @token_type = 'Bearer'
      @expires_in = token.expires_in
      @refresh_token = token.refresh_token
      @resource_owner = resource.class.name
      @resource_id = resource.id
      @created_at = resource.created_at
      @refresh_token_expires_in = token.refresh_expires_in
      @scope = token.scopes
    end

    def current_resource_owner
      return super if defined?(super)
    end
  end
end
