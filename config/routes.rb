Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/', to: 'covsax#index'

  post '/lookup_for_appointment', to: 'covsax#lookup_for_appointment'
end
