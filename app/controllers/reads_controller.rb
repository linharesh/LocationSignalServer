class ReadsController < ApplicationController
  #skip_before_filter :verify_authenticity_token, :only => :create

  # POST /reads
  # POST /reads.json
  def create
    @read = Read.new(read_params)
    add_to_first_layer(@read)
    readAckObject = OpenStruct.new
    readAckObject.objectType = "ReadAck"
    readAckObject.response = "success"
    respond_to do |format|
      format.json { render(json: readAckObject) }
    end
  end

  # GET /reads
  def query
    puts 'query'
  end 


  private

    def set_read
    end

    def add_to_first_layer(pRead)
      alpha = 1
      firstLayer = Layer.find_by(id: 1)
      firstRead = firstLayer.reads.find_by(latitude: pRead.latitude, longitude: pRead.longitude)
      if (firstRead.nil?)
        puts("Adicionando novo read")
        pRead.layer = firstLayer
        pRead.save
      else
        puts("Atualizando valor de read")
        newSignalStrengthValue = (firstRead.signalStrength*1-alpha) + (pRead.signalStrength*alpha)
        firstRead.update(signalStrength: newSignalStrengthValue)
      end
    end

  def calculate_superior_layers
  end


    def read_params
      params.require(:read).permit(:latitude, :longitude, :signalStrength, :carrierName)
    end

end
