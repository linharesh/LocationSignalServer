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
        puts ::Read.all
        newRead = ::Read.create(latitude: pRead.latitude, longitude: pRead.longitude, signalStrength: pRead.signalStrength, carrierName: pRead.carrierName)
        newRead = apply_precision_coeficient(newRead)

        if (firstRead.nil?)
            newRead.layer = Layer.find_by(id: 1)
            newRead.save
        else
            alpha = 1
            newSignalStrengthValue = (firstRead.signalStrength*1-alpha) + (pRead.signalStrength*alpha)
            firstRead.update(signalStrength: newSignalStrengthValue)
        end

    end 

    def apply_precision_coeficient(pRead)
        latitudeInt = Integer(pRead.latitude/self.precision_coeficient)
        pRead.latitude = Float(latitudeInt) * self.precision_coeficient
        longitudeInt = Integer(pRead.longitude/self.precision_coeficient)
        pRead.longitude = Float(longitudeInt) * self.precision_coeficient
        return pRead
    end

    def calculate_layer
        firstLayerReads = Layer.find_by(id: 1).reads
        
        puts 'firstLayerReads'
        puts firstLayerReads

        currentLayerReads = []
        firstLayerReads.each do |flRead|
            puts 'flRead'
            puts flRead
            read = ::Read.create(latitude: flRead.latitude, longitude: flRead.longitude, signalStrength: flRead.signalStrength, carrierName: flRead.carrierName)
            currentLayerReads.push(self.apply_precision_coeficient(read))
        end
        puts '$'
        puts currentLayerReads
        puts '$'
        
        self.reads = self.merge_duplicate_reads(currentLayerReads)
    end

    def merge_duplicate_reads(reads)
        returning_reads = []
        reads.each do |read|
            duplicates = find_duplicates(read, reads)
            if duplicates.count == 1
                returning_reads.push(read)
            else
                returning_reads.push(merge_duplicate_read(duplicates))
            end
        end
    end

    def find_duplicates(current, readsArr)
        duplicates = []
        readsArr.each do |read|
            if (current.latitude == read.latitude && current.longitude == read.longitude)
                duplicates.push(read)
            end
        end
        return duplicates    
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
