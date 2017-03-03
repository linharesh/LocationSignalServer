class AddLayerIdToRead < ActiveRecord::Migration[5.0]
  def change
    add_column :reads, :layer_id, :integer
  end
end
