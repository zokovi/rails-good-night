Rails.application.routes.draw do
  
  resources :sleeps do
    collection do 
      post 'start_sleep' => 'sleeps#start_sleep'
      post 'end_sleep' => 'sleeps#end_sleep'
    end
  end

  resources :users do
    member do
      post 'follow' => 'users#follow'
    end
  end

end
