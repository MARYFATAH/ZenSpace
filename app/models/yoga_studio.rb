class YogaStudio < ApplicationRecord
  belongs_to :user
  has_many :reviews, as: :reviewable
  has_many_attached :photos
  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?

  has_many :yoga_studio_teachers, dependent: :destroy
  has_many :yoga_classes, through: :yoga_studio_teacher

  # validation
  validates :name, presence: true, length: { minimum: 3 }, uniqueness: { scope: :address }
  validates :address, presence: true, length: { minimum: 10 }
  validates :description, presence: true, length: { in: 10..800 }
  # validate :photos_type

  # def photos_type
  #   if photos.attached? == false
  #     errors.add(:photos, ": at least one photo should be attached!")
  #   end
  # end
end
