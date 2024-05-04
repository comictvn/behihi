require 'sidekiq/web'
Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  get 'api-docs/v1/swagger.yaml' => 'swagger#yaml'
  post '/test-progresses/:user_id/:question_id/validate-answer' => 'api/base#validate_answer'
end
