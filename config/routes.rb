Rails.application.routes.draw do
    get '/handshake', :to => 'handshake#index'
end
