class AddStyleToYogaClass < ActiveRecord::Migration[7.0]
  def change
    add_column :yoga_classes, :style, :string
  end
end
