DreamTeam::Application.routes.draw do

  # Admin-only routes
  unless Rails.env.production?
    namespace :admin do
      root :to => "sports#index"
      resources :sports
      resources :projects
      resources :picks
      resources :readers
      resources :unit_actions

      scope ":sport" do
        resources :leagues
        resources :conferences
        resources :divisions
        resources :teams
        resources :players
      end
    end
  end


  scope ":project" do
    resources :picks
    post "picks/update", :to => "picks#update", :as => "update_picks"
    resources :readers
    resources :players
    resources :teams

  end

end
