Rails.application.routes.draw do
  resources :messages
  resources :rooms
  devise_for :users, controllers: {
          registrations: 'users/registrations',
          sessions: 'users/sessions'
        }
  root 'pages#home'
  get 'exams/:exam_id/attemps/new', to: 'attempts#new', as: 'new_attempt'
  post 'exams/:exam_id/attemps/new', to: 'attempts#create', as: 'attempts'
  resources :answers, only: [:update]
  get 'exams/:exam_id/attempts', to: 'attempts#index', as: 'all_attempts'
  resources :attempts, only: [:show]
  resources :exams
  resources :students, only: [:index]
  post 'teachers/:user_id/confirm', to: 'teachers#update', as: 'confirm_teacher'
  resources :teachers, only: [:index]
  get 'student_report/:user_id', to: 'student_reports#show', as: 'report'
  mount ActionCable.server => '/cable'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
