class ReadsController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :create

  # POST /reads
  # POST /reads.json
  def create
    puts("ReadsController # create")
    puts(read_params)
  end

  private
    def set_read
    end

    def read_params
      params.require(:read)
    end

end
