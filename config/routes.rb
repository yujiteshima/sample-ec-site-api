Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      resources :searches
      resources :users
      resources :auths
    end
  end
  match '*path' => 'options_request#preflight', via: :options
end
