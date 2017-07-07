Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :morelit do
    get '/history', action: :history
    get 'images', action: :images
    get '/now', action: :now
  end
end
