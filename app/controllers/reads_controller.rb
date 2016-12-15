class ReadsController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :create

  # POST /reads
  # POST /reads.json
  def create
    puts("ReadsController # create")
    @read = Read.new(read_params)
    @read.save
    puts("Leitura salva com sucesso")
  end

  private
    def set_read
    end

    def read_params
      params.require(:read).permit(:latitude, :longitude, :signalStrength, :carrierName)
    end

end
