Rails.application.routes.draw do
    get '/handshake', :to => 'handshake#index'
    get '/reads', :to => 'reads#query'
    post '/reads', :to => 'reads#create'

end