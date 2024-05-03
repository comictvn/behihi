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

    def authenticate_and_validate_test_progress_update
      doorkeeper_authorize!

      user_id = params[:user_id].to_i
      question_id = params[:question_id].to_i

      unless user_id.is_a?(Integer) && question_id.is_a?(Integer)
        return render json: error_response(nil, StandardError.new("Invalid input format.")), status: :unprocessable_entity
      end

      user = User.find_by(id: user_id)
      unless user
        return render json: error_response(nil, StandardError.new("User not found.")), status: :not_found
      end

      question = Question.find_by(id: question_id)
      unless question
        return render json: error_response(nil, StandardError.new("Question not found.")), status: :not_found
      end

      return user, user_id, question_id
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
