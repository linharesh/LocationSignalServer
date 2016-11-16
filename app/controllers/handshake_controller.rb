class ApplicationController < ActionController::API
    include ActionController::MimeResponds
end

class HandshakeController < ApplicationController

    # GET /handshake 
    def index
    successResponseObject = OpenStruct.new
    successResponseObject.objectType = "handshake object"
    successResponseObject.response = "success"
    successResponseObject.serverName = Rails.application.class.parent_name
        respond_to do |format|
            format.json { render(json: successResponseObject) }
        end
    end
end
