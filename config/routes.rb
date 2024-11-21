Rails.application.routes.draw do
  resources :sleeps do
    collection do 
      post 'start_sleep' => 'sleeps#start_sleep'
      post 'end_sleep' => 'sleeps#end_sleep'
    end
  end
  resources :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
