class Layer < ApplicationRecord
    has_many :reads

    def self.add_read_to_all_layers()
        Layer.where('id != 1').each do |layer|      
            layer.calculate_layer
        end

    end

    def add_read_to_this_layer(pRead) 
        newRead = ::Read.new(latitude: pRead.latitude, longitude: pRead.longitude, signalStrength: pRead.signalStrength, carrierName: pRead.carrierName)
        newRead = apply_precision_coeficient(newRead)
        newRead.layer = Layer.find_by(id: 1)
        newRead.save
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
        currentLayerReads = []
        firstLayerReads.each do |flRead|
            read = ::Read.new(latitude: flRead.latitude, longitude: flRead.longitude, signalStrength: flRead.signalStrength, carrierName: flRead.carrierName)
            read = apply_precision_coeficient(read)
            index = contains(read, currentLayerReads) 
            if (index == -1)
                currentLayerReads.push(read)
            else
                currentLayerReads[index] = consolidate(read, currentLayerReads[index])
            end
            
        end
        currentLayerReads.each do |r|
            r.layer_id = self.id
            r.save
        end
    end

    def contains(read, readsArr)
        readsArr.each do |r|
            return readsArr.index(r) if (r.latitude == read.latitude && r.longitude == read.longitude)
        end
        return -1
    end

    def consolidate(first_read, second_read)
        avg = Float( (first_read.signalStrength + second_read.signalStrength) / 2)
        first_read.signalStrength = avg
        return first_read
    end

end
