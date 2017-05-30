class Layer < ApplicationRecord
    has_many :reads

    def addRead(pRead) 
        firstRead = self.reads.find_by(latitude: pRead.latitude, longitude: pRead.longitude)
        newRead = Read.new(id: read.id, latitude: read.latitude, signalStrength: read.signalStrength, carrierName: read.carrierName)
        applyPrecisionCoeficient(read)

        if (firstRead.nil?)
            puts "Adicionando nova read na layer #{self.id}"
            newRead.layer = self 
            newRead.save
        else
            puts "Atualizando valor de read na layer #{self.id}"
            alpha = 1
            newSignalStrengthValue = (firstRead.signalStrength*1-alpha) + (pRead.signalStrength*alpha)
            firstRead.update(signalStrength: newSignalStrengthValue)
        end

    end 

    def applyPrecisionCoeficient(pRead)

        return pRead
    end


end
