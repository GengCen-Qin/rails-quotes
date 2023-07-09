Rails.application.routes.draw do
  devise_for :users

  get "pages/home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root to: "pages#home"
  resources :quotes

  resources :quotes do
    resources :line_item_dates, except: [:index, :show]
  end

  resources :quotes do
    resources :line_item_dates, except: [:index, :show] do
      resources :line_items, except: [:index, :show]
    end
  end

  # 抛出路由错误异常
  match "*path", to: "application#handle_routing_error", via: :all
end
