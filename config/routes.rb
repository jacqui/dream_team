DreamTeam::Application.routes.draw do
  scope ":project" do
    root :to => 'picks#new'

    resources :unit_actions
    resources :picks
    post "picks/update", :to => "picks#update", :as => "update_picks"
    resources :readers
    resources :players
    resources :teams
  end
end
