Rails.application.routes.draw do
  devise_for :users, controllers: {
          registrations: 'users/registrations'
        }
  root 'pages#home'
  get 'exams/:exam_id/attemps/new', to: 'attempts#new', as: 'new_attempt'
  post 'exams/:exam_id/attemps/new', to: 'attempts#create', as: 'attempts'
  resources :answers, only: [:update]
  get 'exams/:exam_id/attempts', to: 'attempts#index', as: 'all_attempts'
  resources :attempts, only: [:show]
  resources :exams, only: [:new, :create, :index]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
