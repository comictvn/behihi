require 'sidekiq/web'
Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  
  namespace :api do
    resources :questions, only: [] do
      member do
        get 'answers', to: 'questions#show_with_answers'
      end
    end
  end

  get '/health' => 'pages#health_check'
  get 'api-docs/v1/swagger.yaml' => 'swagger#yaml'
end
