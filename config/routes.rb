DreamTeam::Application.routes.draw do
  scope ":project" do
    root :to => 'picks#new'

    resources :unit_actions


    resources :picks


    resources :readers


    resources :players


    resources :teams
  end
end
