Rails.application.routes.draw do
    get '/handshake', :to => 'handshake#index'
    post '/reads', :to => 'reads#create'
end