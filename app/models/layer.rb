class Layer < ApplicationRecord
    has_many :reads

    def addReadToAllLayers(pRead)
        firstLayer = Layer.find_by(id: 1)
        firstLayer.applyPrecisionCoeficient(pRead)
        Layer.where('id != 1').each |layer| do
            layer.calculateLayer
        end
    end

    def addReadToThisLayer(pRead) 
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

    private def applyPrecisionCoeficient(pRead)
        latitudeInt = Integer(pRead.latitude/self.precision_coeficient)
        pRead.latitude = Float(latitudeInt) * self.precision_coeficient
        longitudeInt = Integer(pRead.longitude/self.precision_coeficient)
        pRead.longitude = Float(longitudeInt) * self.precision_coeficient
        return pRead
    end

    private def calculateLayer
        firstLayerReads = firstLayer.reads
        currentLayerReads = []
        firstLayer

        Layer.find_by(id: 1).reads do |flRead|
            read = Read.new(id: flRead.id, latitude: flRead.latitude, signalStrength: flRead.signalStrength, carrierName: flRead.carrierName)
            currentLayerReads.push(self.applyPrecisionCoeficient(read))
        end

        currentLayerReads = self.mergeDuplicatedReads(currentLayerReads)
        #parei aqui
        self.reads = currentLayerReads

    end

    private def mergeDuplicatedReads
    #todo: implementar método
    end

end
