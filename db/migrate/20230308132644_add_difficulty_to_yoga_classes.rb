class AddDifficultyToYogaClasses < ActiveRecord::Migration[7.0]
  def change
    add_column :yoga_classes, :difficulty, :string
  end
end
