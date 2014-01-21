class CreateAmbulances < ActiveRecord::Migration
  def change
    create_table :ambulances do |t|
      t.string  :current_loc
      t.boolean :free
      t.float   :latitude
      t.float   :longitude
      t.integer :equipment_level
      t.timestamps
    end
  end
end