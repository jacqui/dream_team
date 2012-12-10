DreamTeam::Application.routes.draw do

  scope ":project" do

    root :to => 'picks#new'
    resources :picks
    post "picks/update", :to => "picks#update", :as => "update_picks"
    resources :readers
    resources :players
    resources :teams

    # Admin-only routes
    unless Rails.env.production?
      namespace :admin do
        root :to => "teams#index"
        resources :players
        resources :picks
        resources :readers
        resources :teams
        resources :unit_actions
      end
    end
  end
end
