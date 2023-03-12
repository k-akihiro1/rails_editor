Rails.application.routes.draw do
  root to: "home#index"

  namespace 'api' do
    namespace 'v1' do
      resources :articles
      mount_devise_token_auth_for 'User', at: 'auth'
    end
  end
end
