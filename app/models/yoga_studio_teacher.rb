class YogaStudioTeacher < ApplicationRecord
  belongs_to :yoga_studio
  belongs_to :teacher
  has_many :yoga_classes, dependent: :destroy
end
