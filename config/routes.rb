Rails.application.routes.draw do

  # ゲストログイン用
  devise_scope :user do
    post 'users/guest_sign_in', to: 'public/sessions#guest_sign_in'
  end

  # 顧客用
  # URL /users/sign_in ...
  devise_for :users,skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }

  # 管理者用
  # URL /admin/sign_in ...
  devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
    sessions: "admin/sessions"
  }

  scope module: :public do
    root to: "homes#top"
    get '/about' => "homes#about", as: "about"
    get '/search', to: 'searches#search'
    resources :post_images do
      resources :post_comments, only: [:create, :destroy]
      resource :favorites, only: [:create, :destroy]
    end
    resources :users, only: [:index, :show, :edit, :update] do
      resource :relationships, only: [:create, :destroy]
    	get 'followings' => 'relationships#followings', as: 'followings'
    	get 'followers' => 'relationships#followers', as: 'followers'
    end
  end

  namespace :admin do
    resources :users, only:[:index, :show, :edit, :update]
    resources :post_images, only:[:index, :show, :edit, :update]
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

end