Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/contacts', to: 'contacts#parse_csv'
  post '/contacts', to: 'contacts#csv_parsed'
end
