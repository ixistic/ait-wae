Rails.application.routes.draw do
  get 'basic1/index'

  root 'basic1#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
