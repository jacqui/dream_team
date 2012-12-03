DreamTeam::Application.routes.draw do
  scope ":project" do
    root :to => 'picks#new'

    # Admin-only routes
    unless Rails.env.production?
      resources :unit_actions
      resources :picks
      resources :readers
      resources :players
      resources :teams
    end
  end
end
