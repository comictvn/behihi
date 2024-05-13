require 'sidekiq/web'
Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  post '/api/exit-test-completion', to: 'api/users#exit_test_completion'
  
  namespace :api do
    post '/exit-test-completion', to: 'users#exit_test_completion'
  end
  
  get '/health' => 'pages#health_check'
  get 'api-docs/v1/swagger.yaml' => 'swagger#yaml'
end
