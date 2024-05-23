class Teacher < ApplicationRecord
  belongs_to :user
  has_many :reviews, as: :reviewable
  has_one_attached :photo

  has_many :yoga_studio_teachers, dependent: :destroy
  has_many :yoga_classes, through: :yoga_studio_teachers

  # validation
  validates :name, presence: true, length: { in: 3..50 }
  validates :description, presence: true, length: { in: 20..800 }
  validate :photo_attached

  def photo_attached
    if photo.attached? == false
      errors.add(:photo, ": one photo should be attached!")
    end
  end
end
