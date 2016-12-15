Rails.application.routes.draw do
  root to: "static_pages#home"

  namespace :api do
    namespace :v1 do
      match "user" => "users#index", via: :get
      match "user/directories" => "users#directories", via: :get
      match "user/update" => "users#update", via: :put
      match "user/update" => "users#update", via: :patch
      match "randompassword" => "password_entries#randompassword", via: :get

      resources :directory_entries, path: "directories", only: [:index, :show, :info, :create, :update, :destroy] do
        resources :password_entries, path: "passwords", only: [:index, :show, :create, :update, :destroy] do
          collection do
            post :infos
          end
        end

        member do
          post :delete_all
          get :info

          get :check_directory_label
          get :check_password_label
          post :check_password_labels

          post :copy_to
          post :move_to
        end
      end
    end
  end

  devise_for :users
  use_doorkeeper
end
