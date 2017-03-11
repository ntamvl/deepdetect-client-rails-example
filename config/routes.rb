Rails.application.routes.draw do
  get '/docs' => redirect('/api_html/dist/index.html?url=/apidocs/api-docs.json')

  constraints subdomain: 'api' do
    # some namespace
  end

  scope module: 'api' do
    scope module: 'v1' do
      get '/' => 'home#index_public'
    end
    namespace :v1 do
      resources :users
      post '/filter' => 'photos#filter'
      post '/filter_auto_asos' => 'photos#filter_auto_asos'
      post '/predict' => 'photos#predict'
      # match '/filter', to: 'photos#filter', via: 'get'
    end
  end
end
