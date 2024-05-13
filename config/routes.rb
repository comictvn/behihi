require 'sidekiq/web'
Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  get '/health' => 'pages#health_check'
  get 'api-docs/v1/swagger.yaml' => 'swagger#yaml'
  namespace :api do
    post '/exit-test-completion', to: 'users#exit_test_completion'
    post '/users/:user_id/exit_test_completion', to: 'users#exit_test_completion', as: 'exit_test_completion'
  end
end
