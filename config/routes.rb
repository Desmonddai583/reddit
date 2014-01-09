PostitTemplate::Application.routes.draw do
  resources :posts, except: [:destroy] do
    resources :comments, only: [:create]
  end
  resources :users, except: [:destroy]
  resources :categories, except: [:destroy]
  root to: 'posts#index'
end
