Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#index'
  get 'authorize' => 'auth#gettoken'
  get 'events/index'
  get 'calendar_view/graph' => 'calendar_view#graph_index'
  get 'calendar_view/office' => 'calendar_view#office_index'
  get 'calendar_view/index'
  get "extended_properties/new"
  post 'extended_properties/create'
  post 'notify' => 'notifications#handle'
  get 'notifications/index'
  get 'instances/index'

  resources :subscriptions, only: [:index, :new, :create]
end
