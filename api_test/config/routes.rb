Rails.application.routes.draw do
  scope module: :api, defaults: { format: :json }, path: 'api' do
    scope module: :v1, path: 'v1' do
      mount_devise_token_auth_for 'User', at: 'auth', skip: [:registrations, :passwords]
      resources :employees
    end
  end
end
