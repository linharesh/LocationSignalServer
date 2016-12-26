class ReadsController < ApplicationController
  #skip_before_filter :verify_authenticity_token, :only => :create

  # POST /reads
  # POST /reads.json
  def create
    @read = Read.new(read_params)
    @read.save
    readAckObject = OpenStruct.new
    readAckObject.objectType = "ReadAck"
    readAckObject.response = "success"
    respond_to do |format|
      format.json { render(json: readAckObject) }
    end
  end

  private
    def set_read
    end

    def read_params
      params.require(:read).permit(:latitude, :longitude, :signalStrength, :carrierName)
    end

end
