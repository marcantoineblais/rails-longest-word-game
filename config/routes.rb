Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/play', to: 'games#play'
  post '/play', to: 'games#play'
end
