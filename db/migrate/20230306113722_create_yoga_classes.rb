class CreateYogaClasses < ActiveRecord::Migration[7.0]
  def change
    create_table :yoga_classes do |t|
      t.string :name
      t.float :price
      t.text :description
      t.references :user, null: false, foreign_key: true
      t.datetime :start_time
      t.datetime :end_time
      t.integer :capacity
      t.references :yoga_studio_teacher, null: false, foreign_key: true

      t.timestamps
    end
  end
end
