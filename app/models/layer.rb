class Layer < ApplicationRecord
    has_many :reads

    def self.add_read_to_all_layers(pRead)
        Layer.find_by(id: 1).add_read_to_this_layer(pRead)
        Layer.where('id != 1').each do |layer| 
            layer.calculate_layer
        end
    end

    def add_read_to_this_layer(pRead) 
        firstRead = self.reads.find_by(latitude: pRead.latitude, longitude: pRead.longitude)
        puts 'chegou aqui'
        puts ::Read.all
        newRead = ::Read.new(latitude: pRead.latitude, longitude: pRead.longitude, signalStrength: pRead.signalStrength, carrierName: pRead.carrierName)
        newRead = applyPrecisionCoeficient(newRead)

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

    def calculate_layer
        firstLayerReads = Layer.find_by(id: 1).reads
        currentLayerReads = []
        Layer.find_by(id: 1).reads do |flRead|
            read = ::Read.new(latitude: flRead.latitude, signalStrength: flRead.signalStrength, carrierName: flRead.carrierName)
            currentLayerReads.push(self.applyPrecisionCoeficient(read))
        end
        self.reads = self.merge_duplicate_reads(currentLayerReads)
    end

    def merge_duplicate_reads(reads)
        returning_reads = []
        reads.each do |read|
            duplicates = reads.find_by(latitude: read.latitude, longitude: read.longitude)
            if duplicates.count == 1
                returning_reads.push(read)
            else
                returning_reads.push(merge_duplicate_read(duplicates))
            end
        end
    end

    def merge_duplicate_read(duplicates)
        sum = 0
        duplicates.each do |dpl|
            sum = sum + dpl.signalStrength
        end
        avg = Float(sum/duplicates.count)
        first = duplicates.first
        read = ::Read.new(latitude: first.latitude, longitude: first.longitude, signalStrength: avg, carrierName: first.carrierName)
        return read
    end


end
