Rails.application.routes.draw do
  apipie
  get 'api' => redirect('/swagger/dist/index.html?url=/apidocs/api-docs.json')

  get 'api/login/:user_id'=>"api#login"

  get 'api/logout/:user_id/:log_id'=>"api#logout"

  get 'api/user_logs/:user_id'=>"api#user_logs"

  get 'api/users'

  get 'api/not_logged_users'
  get 'api/logged_users'
  get 'api/day_logged_users'
  get 'api/get_user_reports'
  post 'api/save_report'
  get 'index'=>"front#index"
  get 'login'=>"front#login"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "front#login"
  post 'auth/login', to: 'authentication#authenticate'
  post 'auth/create', to: 'authentication#create'

end
