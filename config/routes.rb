Rails.application.routes.draw do
  get "/quotes/:tag", to: "quotes#show"

  post "/login", to: "auth#login"
end
