class HandshakeController < ApplicationController
    # GET /handshake 
    def index
        @message = "syn-ack:" << Rails.application.class.parent_name
    end
end
