class CreateYogaStudioTeachers < ActiveRecord::Migration[7.0]
  def change
    create_table :yoga_studio_teachers do |t|
      t.references :yoga_studio, null: false, foreign_key: true
      t.references :teacher, null: false, foreign_key: true

      t.timestamps
    end
  end
end
