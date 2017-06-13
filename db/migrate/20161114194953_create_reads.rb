class CreateReads < ActiveRecord::Migration[5.0]
  def change
    create_table :reads do |t|
      t.float :latitude
      t.float :longitude
      t.float :signalStrength
      t.string :carrierName
      t.datetime :date

      t.timestamps
    end
  end
end
