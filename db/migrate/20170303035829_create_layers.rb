class CreateLayers < ActiveRecord::Migration[5.0]
  def change
    create_table :layers do |t|

      t.timestamps
    end
  end
end
