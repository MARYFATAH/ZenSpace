class AddCoordinatesToYogaStudios < ActiveRecord::Migration[7.0]
  def change
    add_column :yoga_studios, :latitude, :float
    add_column :yoga_studios, :longitude, :float
  end
end
