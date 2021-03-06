class ReadsController < ApplicationController
  #skip_before_filter :verify_authenticity_token, :only => :create

  # POST /reads
  # POST /reads.json
  def create
    reads_arr = []
    params["count"].times do |i|
      read_params = params[i.to_s]["read"]
      r = Read.new()
      r.latitude = read_params["latitude"]
      r.longitude = read_params["longitude"]
      r.signalStrength = read_params["signalStrength"]
      r.carrierName = read_params["carrierName"]
      r.date = read_params["date"].to_time
      reads_arr.push(r)
    end

    readAckObject = OpenStruct.new
    readAckObject.objectType = "ReadAck"
    readAckObject.response = "success"
    respond_to do |format|
      format.json { render(json: readAckObject) }
    end
    reads_arr.each do |r|
      r.save
      Layer.add_read_to_all_layers(r)  
    end    
  end

  # GET /reads
  def query
    topLeftLatitude = params['topLeftLatitude']
    topLeftLongitude = params['topLeftLongitude']
    bottomRightLatitude = params['bottomRightLatitude']
    bottomRightLongitude = params['bottomRightLongitude']
    layerId = params['layerID']

    selectedLayer = Layer.find_by(id: layerId)
    selectedReads = selectedLayer.reads.where("latitude <= #{topLeftLatitude} AND latitude >= #{bottomRightLatitude} AND longitude >= #{topLeftLongitude} AND longitude <= #{bottomRightLongitude}")
    puts selectedReads
    puts selectedReads.count
    respond_to do |format|
      format.json { render(json: selectedReads) }
    end
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
    Layer.all.where("id != 1").each do |layer|
      puts layer.id
    end
  end


   # def read_params
   #   params.require(:read).permit(:latitude, :longitude, :signalStrength, :carrierName, :date)
   # end

end
