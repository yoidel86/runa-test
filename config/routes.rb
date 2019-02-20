Rails.application.routes.draw do
  get 'api/login/:user_id'=>"api#login"

  get 'api/logout/:user_id/:log_id'=>"api#logout"

  get 'api/userlogs/:user_id'=>"api#userlogs"

  get 'api/users'

  get '/api/notlogedusers'

  get '/api/logedusers'

  get 'index'=>"front#index"
  get 'login'=>"front#login"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "front#login"
  post 'auth/login', to: 'authentication#authenticate'
  post 'auth/create', to: 'authentication#create'

end
