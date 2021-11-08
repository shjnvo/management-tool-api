Rails.application.routes.draw do
  namespace :v1 do
    post 'login', to: 'sessions#create'
    delete 'logout', to: 'sessions#destroy'
    resources :users, except: :index do
      member do
        patch :lock
        patch :unlock
      end
    end

    resources :projects do
      post :invite_user, on: :member
    end
    resources :columns, except: [:index, :show]
    resources :tasks, except: [:index, :show]
  end
end
