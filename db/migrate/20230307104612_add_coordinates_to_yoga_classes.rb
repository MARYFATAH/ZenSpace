class AddCoordinatesToYogaClasses < ActiveRecord::Migration[7.0]
  def change
    add_column :yoga_classes, :latitude, :float
    add_column :yoga_classes, :longitude, :float
  end
end
