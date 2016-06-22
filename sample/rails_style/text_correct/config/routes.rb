Rails.application.routes.draw do
  post 'text_corrections/correct'

  get 'pages/home'
  root 'pages#home'
end
