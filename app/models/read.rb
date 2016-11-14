class Read < ApplicationRecord
    validates_uniqueness_of :latitude, :scope => [:longitude, :carrierName]
end
