DreamTeam::Application.routes.draw do

  scope ":project" do

    root :to => 'picks#new'
    resources :picks

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
