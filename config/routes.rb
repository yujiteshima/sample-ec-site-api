Rails.application.routes.draw do
  # match '*path' => 'options_request#preflight', via: :options
  namespace 'api' do
    namespace 'v1' do
      resources :searches
      resources :users
      resources :auths
    end
  end
  
end
